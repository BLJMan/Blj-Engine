package;

import Conductor.BPMChangeEvent;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;

using StringTools;

class ChartingState extends MusicBeatState
{
	var _file:FileReference;

	var UI_box:FlxUITabMenu;

	/**
	 * Array of notes showing when each section STARTS in STEPS
	 * Usually rounded up??
	 */
	var curSection:Int = 0;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var strumLine:FlxSprite;
	var curSong:String = 'Dadbattle';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;

	var highlight:FlxSprite;

	var GRID_SIZE:Int = 40;

	var dummyArrow:FlxSprite;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;
	var curRenderedEvents:FlxTypedGroup<FlxSprite>;

	var eventShitArray:Array<String> = [];

	var gridBG:FlxSprite;

	var _song:SwagSong;
	var fake_song:SwagSong;

	var isTyping:Bool = false;

	var claps:Array<Note> = [];

	var typingShit:FlxInputText;
	/*
	 * WILL BE THE CURRENT / LAST PLACED NOTE
	**/
	var curSelectedNote:Array<Dynamic>;

	var tempBpm:Int = 0;

	var vocals:FlxSound;

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;

	var daRate:Float = 1;
	var rateTxt:FlxText;

	var diffScrollType:Bool;

	override function create()
	{
		curSection = lastSection;

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 9, GRID_SIZE * 16);
		gridBG.x += 280;
		//gridBG.y += 100;
		add(gridBG);

		//OVERLAY SHIT VERY SORRY
		var shit:FlxSprite = new FlxSprite(FlxG.width / 2, -500).makeGraphic(Std.int(FlxG.width / 2), FlxG.height * 3, FlxColor.BLACK);
		shit.scrollFactor.set();

		#if CHARTING
		leftIcon = new HealthIcon("bf");
		rightIcon = new HealthIcon("dad");
		#else
		leftIcon = new HealthIcon(PlayState.SONG.player2);
		rightIcon = new HealthIcon(PlayState.SONG.player1);
		#end
		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.setGraphicSize(0, 45);
		rightIcon.setGraphicSize(0, 45);

		add(leftIcon);
		add(rightIcon);

		if (!CoolThings.diffScrollType)
		{
			leftIcon.setPosition(320, -100);
			rightIcon.setPosition(gridBG.width / 2 + 320, -100);
		}else 
		{
			leftIcon.setPosition(320, 600);
			rightIcon.setPosition(gridBG.width / 2 + 320, 600);
		}

		var gridBlackLine:FlxSprite = new FlxSprite(gridBG.x + (gridBG.width + 40) / 2, 0).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		var eventsBlackLine:FlxSprite = new FlxSprite(gridBG.x + 39).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(eventsBlackLine);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();
		curRenderedEvents = new FlxTypedGroup<FlxSprite>();

		if (PlayState.SONG != null)
		{
			_song = PlayState.SONG;
		}
		else
		{
			_song = {
				song: 'Test',
				notes: [],
				events: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				gf: "gf",
				arrows: "standard",
				stage: "stage",
				speed: 1,
				validScore: false
			};
		}

		//eventShitArray = CoolUtil.coolTextFile("assets/data/"+ _song.song.toLowerCase() + "/DONT DELETE/eventShit.txt");

		FlxG.mouse.visible = true;
		FlxG.save.bind('funkin', 'ninjamuffin99');

		tempBpm = _song.bpm;

		addSection();

		// sections = _song.notes;

		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		bpmTxt = new FlxText(1000, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();

		strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(FlxG.width / 2) + 80, 4);
		strumLine.screenCenter(X);
		add(strumLine);

		dummyArrow = new FlxSprite(gridBG.x, gridBG.y).makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		updateGrid();

		add(shit); //overlay shit pt.2

		add(bpmTxt);

		var tabs = [
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note'},
			{name: "Event", label: "Event"}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2;
		UI_box.y = 20;
		add(UI_box);
		

		rateTxt = new FlxText(1034, 160, 0, "a", 15);
		rateTxt.color = FlxColor.WHITE;
		rateTxt.scrollFactor.set();
		add(rateTxt);

		var rateButton1:FlxButton = new FlxButton(rateTxt.x - 30, rateTxt.y, "<", function(){daRate -= 0.05;});
		var rateButton2:FlxButton = new FlxButton(rateTxt.x + 45, rateTxt.y, ">", function(){daRate += 0.05;});
		rateButton1.label.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, CENTER);
		rateButton2.label.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, CENTER);
		rateButton1.setGraphicSize(25, 25);
		rateButton1.updateHitbox();
		rateButton2.setGraphicSize(25, 25);
		rateButton2.updateHitbox();
		setAllLabelsOffset(rateButton1, -30, 2.5);
		setAllLabelsOffset(rateButton2, -30, 2.5);
		add(rateButton1);
		add(rateButton2);

		var check_strum_scroll = new FlxUICheckBox(800, 500, null, null, "Change scrolling type", 100);
		check_strum_scroll.checked = CoolThings.diffScrollType;
		check_strum_scroll.scrollFactor.set();
		check_strum_scroll.callback = function()
		{
			if (CoolThings.diffScrollType)
				CoolThings.diffScrollType = false;
			else if (!CoolThings.diffScrollType)
				CoolThings.diffScrollType = true;
			FlxG.resetState();
		};
		add(check_strum_scroll);

		addSongUI();
		addSectionUI();
		addNoteUI();
		addEventUI();

		add(curRenderedNotes);
		add(curRenderedSustains);
		add(curRenderedEvents);

		loadEvents();

		super.create();
	}

	function loadEvents()
	{

	}

	function setAllLabelsOffset(button:FlxButton, x:Float, y:Float)
	{
		for (point in button.labelOffsets)
		{
			point.set(x, y);
		}
	}

	function addSongUI():Void
	{
		var UI_songTitle = new FlxUIInputText(10, 10, 70, _song.song, 8);
		typingShit = UI_songTitle;

		var check_voices = new FlxUICheckBox(10, 25, null, null, "Has voice track", 100);
		check_voices.checked = _song.needsVoices;
		// _song.needsVoices = check_voices.checked;
		check_voices.callback = function()
		{
			_song.needsVoices = check_voices.checked;
			trace('CHECKED!');
		};

		var check_mute_inst = new FlxUICheckBox(10, 200, null, null, "Mute Instrumental (in editor)", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_inst.checked)
				vol = 0;

			FlxG.sound.music.volume = vol;
		};

		var saveButton:FlxButton = new FlxButton(110, 8, "Save", function()
		{
			saveLevel();
		});

		var reloadSong:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload Audio", function()
		{
			loadSong(_song.song);
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, saveButton.y + 30, "Reload JSON", function()
		{
			loadJson(_song.song.toLowerCase());
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', loadAutosave);

		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(10, 80, 0.1, 1, 0.1, 10, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(10, 65, 1, 1, 1, 339, 0);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var gfVersions:Array<String> = CoolUtil.coolTextFile(Paths.txt('gfList'));
		var arrowVersions:Array<String> = CoolUtil.coolTextFile(Paths.txt('arrowsVersionList'));

		var player1DropDown = new FlxUIDropDownMenu(10, 100, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player1 = characters[Std.parseInt(character)];
		});
		player1DropDown.selectedLabel = _song.player1;

		var player2DropDown = new FlxUIDropDownMenu(140, 100, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player2 = characters[Std.parseInt(character)];
		});

		var gfDropDown = new FlxUIDropDownMenu(150, 150, FlxUIDropDownMenu.makeStrIdLabelArray(gfVersions, true), function(gfVersion:String)
		{
			_song.gf = gfVersions[Std.parseInt(gfVersion)];
		});

		var arrowDropDown = new FlxUIDropDownMenu(150, 200, FlxUIDropDownMenu.makeStrIdLabelArray(arrowVersions, true), function(arrowVerion:String)
		{
			_song.arrows = arrowVersions[Std.parseInt(arrowVerion)];
		});

		player2DropDown.selectedLabel = _song.player2;
		gfDropDown.selectedLabel = _song.gf;
		gfDropDown.selectedLabel = _song.arrows;

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";
		tab_group_song.add(UI_songTitle);

		tab_group_song.add(check_voices);
		tab_group_song.add(check_mute_inst);
		tab_group_song.add(saveButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(player1DropDown);
		tab_group_song.add(gfDropDown);
		tab_group_song.add(player2DropDown);
		tab_group_song.add(arrowDropDown);

		UI_box.addGroup(tab_group_song);
		UI_box.scrollFactor.set();

		if (!CoolThings.diffScrollType)
			FlxG.camera.follow(strumLine);

	}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_gfSection:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		stepperLength = new FlxUINumericStepper(10, 10, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSection].lengthInSteps;
		stepperLength.name = "section_length";

		stepperSectionBPM = new FlxUINumericStepper(10, 80, 1, Conductor.bpm, 0, 999, 0);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';

		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(110, 130, 1, 1, -999, 999, 0);

		var copyButton:FlxButton = new FlxButton(10, 130, "Copy last section", function()
		{
			copySection(Std.int(stepperCopy.value));
		});

		var clearSectionButton:FlxButton = new FlxButton(10, 150, "Clear", clearSection);

		var swapSection:FlxButton = new FlxButton(10, 170, "Swap section", function()
		{
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				var note = _song.notes[curSection].sectionNotes[i];
				note[1] = (note[1] + 4) % 8;
				_song.notes[curSection].sectionNotes[i] = note;
				updateGrid();
			}
		});

		check_mustHitSection = new FlxUICheckBox(10, 30, null, null, "Must hit section", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = _song.notes[curSection].mustHitSection;

		check_gfSection = new FlxUICheckBox(110, 30, null, null, "GF section", 100);
		check_gfSection.name = 'check_gf';
		check_gfSection.checked = _song.notes[curSection].gfSection;
		// _song.needsVoices = check_mustHit.checked;

		check_altAnim = new FlxUICheckBox(10, 400, null, null, "Alt Animation", 100);
		check_altAnim.name = 'check_altAnim';

		check_changeBPM = new FlxUICheckBox(10, 60, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';

		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_gfSection);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(swapSection);

		UI_box.addGroup(tab_group_section);
	}

	var stepperSusLength:FlxUINumericStepper;

	function addNoteUI():Void
	{
		var tab_group_note = new FlxUI(null, UI_box);
		tab_group_note.name = 'Note';

		stepperSusLength = new FlxUINumericStepper(10, 10, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 16);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		var applyLength:FlxButton = new FlxButton(100, 10, 'Apply');

		tab_group_note.add(stepperSusLength);
		tab_group_note.add(applyLength);

		UI_box.addGroup(tab_group_note);
	}

	var eventVal1:FlxInputText;
	var eventVal2:FlxInputText;
	var eventType:FlxUIDropDownMenu;

	var daEvent:String;

	function addEventUI():Void
	{
		var tab_group_event = new FlxUI(null, UI_box);
		tab_group_event.name = "Event";

		var events:Array<String> = [" ", "BPMChange", 
		"speedChange", "characterChange", "playAnim", 
		"zoomOnBeat", "hey", "addZoom", "zoomBack", 
		"zoomNormal", "setDefCamZoom", "switchPos", 
		"shakeCam", "hideHUD", "camFocus"];
		
		eventVal1 = new FlxInputText(10, 70, 100);
		eventVal2 = new FlxInputText(10, 110, 100);
		eventType = new FlxUIDropDownMenu(9, 30, FlxUIDropDownMenu.makeStrIdLabelArray(events, true), function(event:String)
		{
			daEvent = events[Std.parseInt(event)];
		});

		var addButton = new FlxButton(10, 150, "add event", function()
		{
			addEvent();
		});

		var loadButton = new FlxButton(10, 200, "load events", function()
		{
			loadAutosave();
		});

		var clearButton = new FlxButton(110, 150, "clear section", function()
		{
			clearSectionEvents();
		});

		var clearALLButton = new FlxButton(110, 200, "clear ALL", function()
		{
			clearEvents();
		});


		tab_group_event.add(addButton);
		tab_group_event.add(loadButton);
		tab_group_event.add(clearButton);
		tab_group_event.add(clearALLButton);
		
		var txt = new FlxText(150, eventType.y, 0, "event type");
		var txt2 = new FlxText(130, eventVal1.y, 0, "value 1");
		var txt3 = new FlxText(130, eventVal2.y, 0, "value 2");

		tab_group_event.add(txt);
		tab_group_event.add(txt2);
		tab_group_event.add(txt3);

		tab_group_event.add(eventVal1);
		tab_group_event.add(eventVal2);
		tab_group_event.add(eventType);

		UI_box.addGroup(tab_group_event);
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			// vocals.stop();
		}

		FlxG.sound.playMusic(Paths.inst(daSong), 0.6);

		// WONT WORK FOR TUTORIAL OR TEST SONG!!! REDO LATER
		vocals = new FlxSound().loadEmbedded(Paths.voices(daSong));
		FlxG.sound.list.add(vocals);

		FlxG.sound.music.pause();
		vocals.pause();

		Conductor.songPosition = sectionStartTime();
		FlxG.sound.music.time = Conductor.songPosition;

		FlxG.sound.music.onComplete = function()
		{
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}

	function generateUI():Void
	{
		while (bullshitUI.members.length > 0)
		{
			bullshitUI.remove(bullshitUI.members[0], true);
		}

		// general shit
		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
		/* 
			var loopCheck = new FlxUICheckBox(UI_box.x + 10, UI_box.y + 50, null, null, "Loops", 100, ['loop check']);
			loopCheck.checked = curNoteSelected.doesLoop;
			tooltips.add(loopCheck, {title: 'Section looping', body: "Whether or not it's a simon says style section", style: tooltipType});
			bullshitUI.add(loopCheck);

		 */
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label)
			{
				case 'Must hit section':
					_song.notes[curSection].mustHitSection = check.checked;

					updateGrid();
					updateHeads();

				case "GF section": 
					_song.notes[curSection].gfSection = check.checked;

					updateGrid();
					updateHeads();

				case 'Change BPM':
					_song.notes[curSection].changeBPM = check.checked;
					FlxG.log.add('changed bpm shit');
				case "Alt Animation":
					_song.notes[curSection].altAnim = check.checked;
			}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
			if (wname == 'section_length')
			{
				_song.notes[curSection].lengthInSteps = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_speed')
			{
				_song.speed = nums.value;
			}
			else if (wname == 'song_bpm')
			{
				tempBpm = Std.int(nums.value);
				Conductor.mapBPMChanges(_song);
				Conductor.changeBPM(Std.int(nums.value));
			}
			else if (wname == 'note_susLength')
			{
				curSelectedNote[2] = nums.value;
				updateGrid();
			}
			else if (wname == 'section_bpm')
			{
				_song.notes[curSection].bpm = Std.int(nums.value);
				updateGrid();
			}
		}

		// FlxG.log.add(id + " WEED " + sender + " WEED " + data + " WEED " + params);
	}

	var updatedSection:Bool = false;

	/* this function got owned LOL
		function lengthBpmBullshit():Float
		{
			if (_song.notes[curSection].changeBPM)
				return _song.notes[curSection].lengthInSteps * (_song.notes[curSection].bpm / _song.bpm);
			else
				return _song.notes[curSection].lengthInSteps;
	}*/
	function sectionStartTime(add:Int = 0):Float
	{
		var daBPM:Int = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection + add)
		{
			if (_song.notes[i].changeBPM)
			{
				daBPM = _song.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.L)
			trace(_song);

		if (!typingShit.hasFocus && !eventVal1.hasFocus && !eventVal2.hasFocus)
		{
			isTyping = false;
		}else 
		{
			isTyping = true;
		}

		if (FlxG.keys.justPressed.U)
			trace(_song.events, PlayState.SONG.events);
		if (FlxG.keys.justPressed.Y && !isTyping)
			addEvent();
		
		FlxG.watch.addQuick("s", diffScrollType);
		FlxG.watch.addQuick("sd", FlxG.save.data.eventautosave);
		FlxG.watch.addQuick("aws", _song.events);

		if (!FlxG.mouse.overlaps(gridBG))
			dummyArrow.visible = false;
		else 
			dummyArrow.visible = true;


		rateTxt.text = Std.string(daRate);

		if (rateTxt.text == "1")
			rateTxt.text = "1.00";

		#if cpp
		@:privateAccess
		{
			if (FlxG.sound.music.playing)
				lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, daRate);
			if (vocals.playing)
				lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, daRate);
		}
		#end

		FlxG.watch.addQuick("start", sectionStartTime());
		FlxG.watch.addQuick("sped", daRate);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			LoadingState.loadAndSwitchState(new ChartingPlayState(sectionStartTime()));
		}
		curRenderedNotes.forEach(function(note:Note)
		{
			if (FlxG.sound.music.playing)
			{
				FlxG.overlap(strumLine, note, function(_, _)
				{
					if(!claps.contains(note))
					{
						claps.push(note);
						FlxG.sound.play(Paths.sound('SNAP'));
					}
				});
			}

			if (note.y < strumLine.y - 2)
			{
				note.alpha = 0.35;
			} else if (note.y > strumLine.y + 2)
			{
				note.alpha = 1;
			}
		});

		curStep = recalculateSteps();

		Conductor.songPosition = FlxG.sound.music.time;
		_song.song = typingShit.text;

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps));

		if (curBeat % 4 == 0 && curStep >= 16 * (curSection + 1))
		{
			trace(curStep);
			trace((_song.notes[curSection].lengthInSteps) * (curSection + 1));
			trace('DUMBSHIT');

			if (_song.notes[curSection + 1] == null)
			{
				addSection();
			}

			changeSection(curSection + 1, false);
		}

		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(curRenderedNotes))
			{
				curRenderedNotes.forEach(function(note:Note)
				{
					if (FlxG.mouse.overlaps(note))
					{
						if (FlxG.keys.pressed.CONTROL)
						{
							selectNote(note);
						}
						else
						{
							trace('tryin to delete note...');
							deleteNote(note);
						}
					}
				});
			}
			else
			{
				if (FlxG.mouse.x > (gridBG.x + 40)
					&& FlxG.mouse.x < gridBG.x + gridBG.width
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
				{
					
					FlxG.log.add('added note');
					addNote();
					
				}
			}
		}

		if (FlxG.mouse.x > gridBG.x && FlxG.mouse.x < gridBG.x + gridBG.width && FlxG.mouse.y > gridBG.y && FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
		{
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;

			if (FlxG.keys.pressed.SHIFT)
				dummyArrow.y = FlxG.mouse.y;
			else
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			lastSection = curSection;

			PlayState.SONG = _song;
			FlxG.sound.music.stop();
			vocals.stop();
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.E && !isTyping)
		{
			changeNoteSustain(Conductor.stepCrochet);
		}
		if (FlxG.keys.justPressed.Q && !isTyping)
		{
			changeNoteSustain(-Conductor.stepCrochet);
		}

		if (FlxG.keys.justPressed.TAB)
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				UI_box.selected_tab -= 1;
				if (UI_box.selected_tab < 0)
					UI_box.selected_tab = 2;
			}
			else
			{
				UI_box.selected_tab += 1;
				if (UI_box.selected_tab >= 3)
					UI_box.selected_tab = 0;
			}
		}

		if (!typingShit.hasFocus)
		{
			if (FlxG.keys.justPressed.SPACE && !isTyping)
			{
				if (FlxG.sound.music.playing)
				{
					FlxG.sound.music.pause();
					vocals.pause();
					claps.splice(0, claps.length);
				}
				else
				{
					vocals.play();
					FlxG.sound.music.play();
				}
			}

			if (FlxG.keys.justPressed.R && !isTyping)
			{
				if (FlxG.keys.pressed.SHIFT)
					resetSection(true);
				else
					resetSection();
			}

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				claps.splice(0, claps.length);

				FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.4);
				vocals.time = FlxG.sound.music.time;
			}

			if (!FlxG.keys.pressed.SHIFT && !isTyping)
			{
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = 700 * FlxG.elapsed;

					if (FlxG.keys.pressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
			else if (!isTyping)
			{
				if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();
					claps.splice(0, claps.length);

					var daTime:Float = Conductor.stepCrochet * 2;

					if (FlxG.keys.justPressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
		}

		_song.bpm = tempBpm;

		/* if (FlxG.keys.justPressed.UP)
				Conductor.changeBPM(Conductor.bpm + 1);
			if (FlxG.keys.justPressed.DOWN)
				Conductor.changeBPM(Conductor.bpm - 1); */

		var shiftThing:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftThing = 4;
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D && !isTyping)
			changeSection(curSection + shiftThing);
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A && !isTyping)
			changeSection(curSection - shiftThing);

		bpmTxt.text = bpmTxt.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ " / "
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			+ "\nSection: "
			+ curSection
			+ "\ncurBeat: "
			+ curBeat
			+ "\ncurStep: "
			+ curStep
			+ "\ncurBPM: "
			+ Conductor.bpm;
		super.update(elapsed);
	}

	function changeNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[2] != null)
			{
				curSelectedNote[2] += value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}

		updateNoteUI();
		updateGrid();
	}

	function recalculateSteps():Int
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void
	{
		updateGrid();

		FlxG.sound.music.pause();
		vocals.pause();

		// Basically old shit from changeSection???
		FlxG.sound.music.time = sectionStartTime();

		if (songBeginning)
		{
			FlxG.sound.music.time = 0;
			curSection = 0;
		}

		vocals.time = FlxG.sound.music.time;
		updateCurStep();

		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		trace('changing section' + sec);

		if (_song.notes[sec] != null)
		{
			curSection = sec;

			updateGrid(true);

			if (updateMusic)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				/*var daNum:Int = 0;
					var daLength:Float = 0;
					while (daNum <= sec)
					{
						daLength += lengthBpmBullshit();
						daNum++;
				}*/

				FlxG.sound.music.time = sectionStartTime();
				vocals.time = FlxG.sound.music.time;
				updateCurStep();
			}

			updateGrid(true);
			updateSectionUI();
		}
	}

	function copySection(?sectionNum:Int = 1)
	{
		var daSec = FlxMath.maxInt(curSection, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes)
		{
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);

			var copiedNote:Array<Dynamic> = [strum, note[1], note[2]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}

		updateGrid();
	}

	function updateSectionUI():Void
	{
		var sec = _song.notes[curSection];

		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_gfSection.checked = sec.gfSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;

		updateHeads();
	}

	function updateHeads():Void
	{
		#if CHARTING	
		if (check_mustHitSection.checked)
		{
			leftIcon.animation.play("dad");
			rightIcon.animation.play("bf");
			if (_song.notes[curSection].gfSection) leftIcon.animation.play('gf');
		}
		else
		{
			leftIcon.animation.play("bf");
			rightIcon.animation.play("dad");
			if (_song.notes[curSection].gfSection) leftIcon.animation.play('gf');
		}
		#else
		if (check_mustHitSection.checked)
		{
			leftIcon.animation.play(PlayState.SONG.player1);
			rightIcon.animation.play(PlayState.SONG.player2);
			if (_song.notes[curSection].gfSection) leftIcon.animation.play('gf');
		}
		else
		{
			leftIcon.animation.play(PlayState.SONG.player2);
			rightIcon.animation.play(PlayState.SONG.player1);
			if (_song.notes[curSection].gfSection) leftIcon.animation.play('gf');
		}
		#end
	}

	function updateNoteUI():Void
	{
		if (curSelectedNote != null)
			stepperSusLength.value = curSelectedNote[2];
	}

	function updateGrid(lol:Bool = false):Void
	{
		while (curRenderedNotes.members.length > 0)
		{
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		}

		while (curRenderedSustains.members.length > 0)
		{
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		}

		if (lol)
			while (curRenderedEvents.members.length > 0)
			{
				curRenderedEvents.remove(curRenderedEvents.members[0], true);
			}

		if (_song.events != null)
		for (event in _song.events)
		{
			var data = event.visPos.split(",");
			if (Std.parseInt(data[1]) == curSection)
			{
				var blackShit:FlxSprite = new FlxSprite(gridBG.x + 5, getYfromStrum(Std.parseFloat(data[0]) - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps) - 15).loadGraphic(Paths.image("event"));
				blackShit.antialiasing = true;
				//blackShit.scale.set(0.8, 0.8);
				curRenderedEvents.add(blackShit);
				trace("added event" + Std.parseInt(data[1]), curSection, Std.parseFloat(data[0]), blackShit.y);
			}
		} 

		var sectionInfo:Array<Dynamic> = _song.notes[curSection].sectionNotes;

		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0)
		{
			Conductor.changeBPM(_song.notes[curSection].bpm);
			FlxG.log.add('CHANGED BPM!');
		}
		else
		{
			// get last bpm
			var daBPM:Int = _song.bpm;
			for (i in 0...curSection)
				if (_song.notes[i].changeBPM)
					daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}

		/* // PORT BULLSHIT, INCASE THERE'S NO SUSTAIN DATA FOR A NOTE
			for (sec in 0..._song.notes.length)
			{
				for (notesse in 0..._song.notes[sec].sectionNotes.length)
				{
					if (_song.notes[sec].sectionNotes[notesse][2] == null)
					{
						trace('SUS NULL');
						_song.notes[sec].sectionNotes[notesse][2] = 0;
					}
				}
			}
		 */

		for (i in sectionInfo)
		{
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];
			var daType = i[3];

			var note:Note = new Note(daStrumTime, daNoteInfo % 4, null, false, daType);
			note.sustainLength = daSus;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.x = Math.floor((daNoteInfo) * GRID_SIZE) + 320;
			note.updateHitbox();
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));

			curRenderedNotes.add(note);

			if (daSus > 0)
			{
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2),
					note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * 16, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}

			FlxG.watch.addQuick("d", note.x);

		}

	}

	private function addSection(lengthInSteps:Int = 16):Void
	{
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			gfSection : false,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: false
		};

		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void
	{
		var swagNum:Int = 0;

		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i.strumTime == note.strumTime && i.noteData % 4 == note.noteData)
			{
				curSelectedNote = _song.notes[curSection].sectionNotes[swagNum];
			}

			swagNum += 1;
		}

		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void
	{
		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i[0] == note.strumTime && i[1] % 4 == note.noteData)
			{
				FlxG.log.add('FOUND EVIL NUMBER');
				_song.notes[curSection].sectionNotes.remove(i);
			}
		}

		updateGrid();
	}

	function clearSection():Void
	{
		_song.notes[curSection].sectionNotes = [];

		updateGrid(true);
	}

	function clearSectionEvents()
	{
		for (event in _song.events)
		{
			var data = event.visPos.split(",");
			if (Std.parseInt(data[1]) == curSection)
			{
				_song.events.remove(event);
			}
		}

		updateGrid(true);
		updateGrid();
	}

	function clearEvents()
	{
		_song.events = [];
	}

	function clearSong():Void
	{
		for (daSection in 0..._song.notes.length)
		{
			_song.notes[daSection].sectionNotes = [];
		}

		//_song.events = [];
		//eventShitArray = [];

		updateGrid(true);
	}

	private function addEvent() 
	{
		//var blackShit:FlxSprite = new FlxSprite(gridBG.x, strumLine.y).makeGraphic(GRID_SIZE, 10, FlxColor.BLACK);
		//curRenderedEvents.add(blackShit);
		var val1 = Std.parseFloat(eventVal1.text);
		var val2 = eventVal2.text;
		var type = daEvent;
		var position = Std.string(Conductor.songPosition + "," + curSection);

		var pog:SongEvent = new SongEvent(curStep, val1, val2, type, position);
		_song.events.push(pog);
		trace(_song.events + "  " + daEvent);
		//eventShitArray.push(Std.string(Conductor.songPosition + "," + curSection));
		//trace(eventShitArray);

		updateGrid();
		autosaveSong();
	}

	private function addNote():Void
	{
		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteData = Math.floor((FlxG.mouse.x - 320) / GRID_SIZE);
		var noteSus = 0;
		var noteType = 0;
		if (FlxG.keys.pressed.ONE)
			noteType = 1;
		if (FlxG.keys.pressed.Z)
			noteType = 2;
		if (FlxG.keys.pressed.X)
			noteType = 3;

		_song.notes[curSection].sectionNotes.push([noteStrum, noteData, noteSus, noteType]);

		curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		if (FlxG.keys.pressed.CONTROL)
		{
			_song.notes[curSection].sectionNotes.push([noteStrum, (noteData + 4) % 8, noteSus, noteType]);
		}

		trace(noteStrum);
		trace(curSection);
		trace("notetype " + noteType);

		updateGrid();
		updateNoteUI();

		autosaveSong();
	}

	function getStrumTime(yPos:Float):Float
	{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float
	{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}

	/*
		function calculateSectionLengths(?sec:SwagSection):Int
		{
			var daLength:Int = 0;

			for (i in _song.notes)
			{
				var swagLength = i.lengthInSteps;

				if (i.typeOfSection == Section.COPYCAT)
					swagLength * 2;

				daLength += swagLength;

				if (sec != null && sec == i)
				{
					trace('swag loop??');
					break;
				}
			}

			return daLength;
	}*/
	private var daSpacing:Float = 0.3;

	function loadLevel():Void
	{
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic>
	{
		var noteData:Array<Dynamic> = [];

		for (i in _song.notes)
		{
			noteData.push(i.sectionNotes);
		}

		return noteData;
	}

	function loadJson(song:String):Void
	{
		PlayState.SONG = Song.loadFromJson(song.toLowerCase(), song.toLowerCase());
		FlxG.resetState();
	}

	function loadAutosave():Void
	{
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		FlxG.resetState();
	}

	function autosaveSong():Void
	{
		FlxG.save.data.autosave = Json.stringify({
			"song": _song
		});

		FlxG.save.flush();
	}

	private function saveLevel()
	{
		var json = {
			"song": _song
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + ".json");
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}
