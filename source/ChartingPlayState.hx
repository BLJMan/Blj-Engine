package;

import flixel.graphics.FlxGraphic;
import Section.SwagSection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;

using StringTools;

class ChartingPlayState extends MusicBeatState
{
	private var vocals:FlxSound;
	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];
	private var strumLine:FlxSprite;
	private var curSection:Int = 0;
	private var SplashNote:NoteSplash;
	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<StrumNote>;
	private var cpuStrums:FlxTypedGroup<StrumNote>;
	private var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	private var combo:Int = 0;
	private var generatedMusic:Bool = false;
	var noteSplashOp:Bool;
	var mashViolations:Int = 0;
	var mashing:Int = 0;
	var totalNotes:Int = 0;
	var songLength:Float = 0;
	var floatshit:Float = 0;
	var startOffset:Float = 0;
	var startPos:Float = 0;
	var timerToStart:Float = 0;
	var bpmText:FlxText;
	var stepText:FlxText;
	var beatText:FlxText;
	public static var daPixelZoom:Float = 6;
	public static var notesForNow:Int = 0;

	public function new(startPos:Float) 
	{
		this.startPos = startPos;
		Conductor.songPosition = startPos - startOffset;

		startOffset = Conductor.crochet;
		timerToStart = startOffset;
		super();
	}

	override public function create()
	{
		FlxG.watch.addQuick("persist", FlxGraphic.defaultPersist);
		//FlxGraphic.defaultPersist = false;

		CoolUtil.arrowHSV = CoolUtil.fakeArrowHSV;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		var sploosh = new NoteSplash(100, 100, 0);
		sploosh.antialiasing = CoolThings.antialiasing;
		grpNoteSplashes.add(sploosh);

		persistentUpdate = true;
		persistentDraw = true;

		Conductor.mapBPMChanges(PlayState.SONG);
		Conductor.changeBPM(PlayState.SONG.bpm);
		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if (PlayState.SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();


		playerStrums = new FlxTypedGroup<StrumNote>();
		cpuStrums = new FlxTypedGroup<StrumNote>();

		generateSong(PlayState.SONG.song);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		bpmText = new FlxText(20, 550, 0, "", 25);
		bpmText.scrollFactor.set();
		add(bpmText);

		generateStaticArrows(0);
		generateStaticArrows(1);

		super.create();
	}

	function startSong():Void
	{
		startingSong = false;
		FlxG.sound.music.time = startPos;
		FlxG.sound.music.play();
		FlxG.sound.music.volume = 1;
		vocals.volume = 1;
		vocals.time = startPos;
		vocals.play();
	}

	var startingSong:Bool = true;

	private function generateSong(dataPath:String):Void
	{
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.pause();
		FlxG.sound.music.onComplete = endSong;
		vocals.pause();
		vocals.volume = 0;

		var songData = PlayState.SONG;
		Conductor.changeBPM(songData.bpm);
		
		notes = new FlxTypedGroup<Note>();
		add(notes);
		
		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] - FlxG.save.data.offset;

				if (daStrumTime >= startPos)
				{
					var daNoteData:Int = Std.int(songNotes[1] % 4);

					var gottaHitNote:Bool = section.mustHitSection;

					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}

					var oldNote:Note;
					var daType = songNotes[3];
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
					totalNotes ++;
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);

					var susLength:Float = swagNote.sustainLength;

					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);

					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
						totalNotes ++;
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						sustainNote.mustPress = gottaHitNote;

						if (sustainNote.mustPress)
						{
							sustainNote.x += (FlxG.width / 2) + 50; // general offset
						}else 
						{
							sustainNote.x += 50;
						}
					}

					swagNote.mustPress = gottaHitNote;

					if (swagNote.mustPress)
					{
						swagNote.x += (FlxG.width / 2) + 50; // general offset
					}
					else 
					{
						swagNote.x += 50;
					}
				}
			}
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, i, player);

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.alpha = 0;
			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.afterGenerating();
		}
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	override public function update(elapsed:Float)
	{
	//	bpmText.text = "curBPM: " + Conductor.bpm;
		//stepText.text = "curStep: " + curStep;
	//	beatText.text = "curBeat: " + curBeat;

		FlxG.watch.addQuick("start", startPos);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			endSong();
			vocals.destroy();
			persistentUpdate = false;
			persistentDraw = false;
		}

		if (startingSong) 
		{
			timerToStart -= elapsed * 1000;
			Conductor.songPosition = startPos - timerToStart;

			if(timerToStart < 0) 
			{
				startSong();
			}

		} else 
		{
			Conductor.songPosition += elapsed * 1000;
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		bpmText.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ " / "
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			+ "\ncurBeat: "
			+ curBeat
			+ "\ncurStep: "
			+ curStep
			+ "\ncurBPM: "
			+ Conductor.bpm
			+ "\n";


		var roundedSpeed:Float = FlxMath.roundDecimal(PlayState.SONG.speed, 2);
		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1800)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			var fakeCrochet:Float = (60 / PlayState.SONG.bpm) * 1000;

			notes.forEachAlive(function(daNote:Note)
			{
				// i am so fucking sorry for this if condition

				var strumX:Float = 0;
				var strumY:Float = 0;

				if(daNote.mustPress) 
				{
					strumX = playerStrums.members[daNote.noteData].x;
					strumY = playerStrums.members[daNote.noteData].y;
				} else 
				{
					strumX = cpuStrums.members[daNote.noteData].x;
					strumY = cpuStrums.members[daNote.noteData].y;
				}
				var center:Float = strumY + Note.swagWidth / 2;

				if (CoolThings.downscroll) 
				{
					daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

					if (daNote.isSustainNote) 
					{
						//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
						if (daNote.animation.curAnim.name.endsWith('end')) 
						{
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;

							if(PlayState.isPixelArrows) {
								daNote.y += 8;
							}
						} 

						daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
						daNote.y += 27.5 * ((PlayState.SONG.bpm / 100) - 1) * (roundedSpeed - 1);

						if(daNote.mustPress || !daNote.ignoreNote)
						{
							if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
								&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
				} else 
				{
	
					daNote.y = (strumY  - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

					if(daNote.isSustainNote)
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;
		
							daNote.clipRect = swagRect;
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					cpuNoteHit(daNote);
				}

				if(daNote.mustPress && CoolThings.botplay) 
				{
					if (daNote.noteType != 3)
					{
						if(daNote.isSustainNote) 
						{
							if(daNote.canBeHit) 
							{
								goodNoteHit(daNote);
							}
			
						} else if (daNote.strumTime <= Conductor.songPosition) 
						{
							goodNoteHit(daNote);
						}
					}
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var killNote:Bool = daNote.y < -daNote.height;
				if(CoolThings.downscroll) 
				{
					killNote = daNote.y > FlxG.height;
				}

				if (killNote)
				{
					if (daNote.mustPress && !CoolThings.botplay && !endingSong)
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
						{
							
							//Dupe note remove
							notes.forEachAlive(function(note:Note) 
							{
								if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 10) 
								{
									note.kill();
									notes.remove(note, true);
									note.destroy();
								}
							});

							
						}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		cpuStrums.forEach(function(spr:StrumNote)
		{
			if (spr.animation.finished)
			{
				spr.playAnim('static');
				spr.centerOffsets();
			}
		});

		keyShit();
	}

	function endSong():Void
	{
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		FlxG.switchState(new ChartingState());
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 0;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25) 
		{
			daRating = 'good';
			score = 200;
		}

		if(daRating == 'sick')
		{
			if (CoolThings.doSplash)
				makeSplash(daNote);
		}

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.curStage.startsWith('school'))
		{
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40 - 200;
		rating.y += 40;
		rating.acceleration.y = 550;
		rating.scrollFactor.set(0.3, 0.3);
		rating.scale.set(0.55, 0.55);
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = false;

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x - 15 - 200;
		comboSpr.y += 100;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.scale.set(0.75, 0.75);
		comboSpr.scrollFactor.set(0.3, 0.3);
		comboSpr.visible = false;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		//add(rating);

		if (!PlayState.curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = CoolThings.antialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = CoolThings.antialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 290;
			numScore.y += 180;
			numScore.scale.set(0.55, 0.55);
			numScore.scrollFactor.set(0.3, 0.3);

		if (!PlayState.curStage.startsWith('school'))
		{
			numScore.antialiasing = CoolThings.antialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
		}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
			{
				add(numScore);
			}

			if (combo >=10)
				//add(comboSpr);


			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}

		coolText.text = Std.string(seperatedScore);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	function makeSplash(daNote:Note):Void
	{
		var recycledNote = grpNoteSplashes.recycle(NoteSplash);
		recycledNote.setupNoteSplash(daNote.x, strumLine.y, daNote.noteData);
		recycledNote.antialiasing = CoolThings.antialiasing;
		grpNoteSplashes.add(recycledNote);
	}

	private function keyShit():Void // I've invested in emma stocks
	{

			// control arrays, order L D R U
			var holdArray:Array<Bool> = [
				controls.LEFT, 
				controls.DOWN, 
				controls.UP, 
				controls.RIGHT
			];

			var pressArray:Array<Bool> = [
				controls.LEFT_P,
				controls.DOWN_P,
				controls.UP_P,
				controls.RIGHT_P
			];

			var releaseArray:Array<Bool> = [
				controls.LEFT_R,
				controls.DOWN_R,
				controls.UP_R,
				controls.RIGHT_R
			];
	 
			
			
			// HOLDS, check for sustain notes
			if (holdArray.contains(true) &&  generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
						goodNoteHit(daNote);
				});
			}

	 
			// PRESSES, check for note hits
			if (pressArray.contains(true)/* && !boyfriend.stunned*/ &&  generatedMusic)
			{
				
	 
				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
				//var daNote = possibleNotes[0];
	 
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					{
						if (directionList.contains(daNote.noteData))
						{
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				});
	 
				for (note in dumbNotes)
				{
					//FlxG.log.add("killing dumb ass note at " + note.strumTime);
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
	 
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	 
				var dontCheck = false;

				for (i in 0...pressArray.length)
				{
					if (pressArray[i] && !directionList.contains(i))
						dontCheck = true;
				}

				

				if (possibleNotes.length > 0 && !dontCheck)
				{
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData])
						{
							if (mashViolations != 0)
								mashViolations--;
							goodNoteHit(coolNote);
						}
					}
				}

			}
			
			notes.forEachAlive(function(daNote:Note)
			{
				if(CoolThings.downscroll && daNote.y > strumLine.y ||
				!CoolThings.downscroll && daNote.y < strumLine.y)
				{
					// Force good note hit regardless if it's too late to hit it or not as a fail safe
					if(CoolThings.botplay && daNote.canBeHit && daNote.mustPress ||
					CoolThings.botplay && daNote.tooLate && daNote.mustPress)
					{
						if (daNote.noteType != 3)
						{
							goodNoteHit(daNote);
							
						}
						
					}
				}
			});
	 
			if (!CoolThings.botplay)
			{
				playerStrums.forEach(function(spr:StrumNote)
				{

					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
					{
						spr.playAnim('pressed');
						//spr.resetAnim = 0;
					}
					if (!holdArray[spr.ID])
					{
						spr.playAnim('static');
						//spr.resetAnim = 0;
					}	 
					if (spr.animation.curAnim.name == 'confirm' && !PlayState.isPixelArrows)
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}
	}

	

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		if (mashing != 0)
			mashing = 0;

		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;

		if (mashViolations < 0)
			mashViolations = 0;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				combo += 1;
			}

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.playAnim('confirm', true);
				}
				if (spr.animation.curAnim.name == 'confirm' && !PlayState.isPixelArrows)
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
	
			note.wasGoodHit = true;
			vocals.volume = 1;
	
			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}		
		}
	}

	function cpuNoteHit(note:Note):Void
	{		
		cpuStrums.forEach(function(spr:StrumNote)
		{
			if (Math.abs(note.noteData) == spr.ID)
			{
				spr.playAnim('confirm', true);
			}
			if (spr.animation.curAnim.name == 'confirm' && !PlayState.isPixelArrows)
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	
		//note.wasGoodHit = true;
		//vocals.volume = 1;
	
		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}


	function spawnNoteSplashOnNote(note:Note) 
	{
		notes.forEachAlive(function(daNote:Note)
		{
			spawnNoteSplash(note.x, note.y, note.noteData);
		});
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int) 
	{
		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data);
		grpNoteSplashes.add(splash);
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, CoolThings.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (PlayState.SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (PlayState.SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(PlayState.SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
		}
	}
}