package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var canAutoAnim:Bool = true;

	public var isBf:Bool = false;
	
	public var holdTimer:Float = 0;

	public var doubleAnim:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = CoolThings.antialiasing;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets', 'shared', true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				doubleAnim = true;

				/*addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);*/

				loadOffset(curCharacter);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('gfChristmas', 'shared', true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				doubleAnim = true;

				/*addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);*/

				addOffset('scared', -2, -17);

				loadOffset(curCharacter);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('gfCar', 'shared', true);
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				doubleAnim = true;

				/*addOffset('danceLeft', 0);
				addOffset('danceRight', 0);*/

				loadOffset(curCharacter);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('gfPixel', 'shared', true);
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				doubleAnim = true;

				/*addOffset('danceLeft', 0);
				addOffset('danceRight', 0);*/

				loadOffset(curCharacter);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				/*addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);*/

				loadOffset(curCharacter);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('spooky_kids_assets','shared',true);
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				doubleAnim = true;

				/*addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);*/

				loadOffset(curCharacter);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('Mom_Assets','shared',true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				/*addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);*/

				loadOffset(curCharacter);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('momCar','shared',true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				/*addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);*/

				loadOffset(curCharacter);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('Monster_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				/*addOffset('idle', 0, -10);
				addOffset("singUP", -20, 77);
				addOffset("singRIGHT", -51, 4);
				addOffset("singLEFT", -30, -5);
				addOffset("singDOWN", -30, -96);*/

				loadOffset(curCharacter);

				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('monsterChristmas','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				/*addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);*/

				loadOffset(curCharacter);

				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('Pico_FNF_assetss','shared',true);
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				/*addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);*/

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				/*addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);*/

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('bfChristmas','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				/*addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);*/

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfCar','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				/*addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);*/

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('bfPixel','shared',true);
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				/*addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");*/

				loadOffset(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('bfPixelsDEAD','shared',true);
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, false);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				/*addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);*/

				loadOffset(curCharacter);

				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('senpai','shared',true);
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				/*addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);*/

				loadOffset(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('senpai','shared',true);
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				/*addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);*/

				loadOffset(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('spirit','shared',true);
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				/*addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);*/

				loadOffset(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('mom_dad_christmas_assets','shared',true);
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				/*addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);*/

				loadOffset(curCharacter);

				playAnim('idle');

			case "tankman":
				tex = Paths.getSparrowAtlas('tankmanCaptain', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note ', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note ', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note ', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left ', 24, false);

				animation.addByPrefix('ughAnim', 'TANKMAN UGH', 24, false);
				animation.addByPrefix('prettyGoodAnim', 'PRETTY GOOD', 24, false);

				/*addOffset('idle');
				addOffset("singUP", 24, 56);
				addOffset("oldSingUP", 24, 56);
				addOffset("singRIGHT", -1, -7);
				addOffset("singLEFT", 100, -14);
				addOffset("singDOWN", 98, -90);
				addOffset("oldSingDOWN", 98, -90);
				//addOffset("ughAnim", 45, 0);
				addOffset("prettyGoodAnim", 45, 20);*/

				loadOffset(curCharacter);
				
				playAnim('idle');
				flipX = true;

			case 'gf-tankman':
				frames = Paths.getSparrowAtlas('gfTankmen', 'shared', true);
				
				animation.addByPrefix('cheer', 'GF Dancing at Gunpoint', 24, false);
				animation.addByPrefix('singLEFT', 'GF Dancing at Gunpoint', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Dancing at Gunpoint', 24, false);
				animation.addByPrefix('singUP', 'GF Dancing at Gunpoint', 24, false);
				animation.addByPrefix('singDOWN', 'GF Dancing at Gunpoint', 24, false);
				animation.addByIndices('sad', 'GF Crying at Gunpoint ', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				doubleAnim = true;

				loadOffset(curCharacter);

				updateHitbox();
				

				playAnim('danceRight');

			case 'gf-IHY':
				frames = Paths.getSparrowAtlas('Girlfriend_IHY', 'shared', true);
				
				animation.addByPrefix('sad', 'gf sad0', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat0', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				doubleAnim = true;

				loadOffset(curCharacter);

				updateHitbox();
				
				playAnim('danceRight');

			case 'picoSpeaker':
				
				tex = Paths.getSparrowAtlas('picoSpeaker', 'shared', true);
				frames = tex;
				
				animation.addByIndices('idle', 'Pico shoot 1', [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], "", 24, true);

				animation.addByIndices('shoot1', 'Pico shoot 1', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, true);
				animation.addByIndices('shoot2', 'Pico shoot 2', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('shoot3', 'Pico shoot 3', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('shoot4', 'Pico shoot 4', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				
				/*addOffset('shoot1', 0, 0);
				addOffset('shoot2', -1, -128);
				addOffset('shoot3', 412, -64);
				addOffset('shoot4', 439, -19);*/

				loadOffset(curCharacter);

				playAnim('shoot1');

			case 'bf-holding-gf':
				
				frames = Paths.getSparrowAtlas('bfAndGF', 'shared', true);
				animation.addByPrefix('idle', 'BF idle dance w gf0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);
				
				/*addOffset('idle', 0, 0);
				addOffset("singUP", -29, 10);
				addOffset("singRIGHT", -41, 23);
				addOffset("singLEFT", 12, 7);
				addOffset("singDOWN", -10, -10);
				addOffset("singUPmiss", -29, 10);
				addOffset("singRIGHTmiss", -41, 23);
				addOffset("singLEFTmiss", 12, 7);
				addOffset("singDOWNmiss", -10, -10);*/

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;
			
			case "chara":
				tex = Paths.getSparrowAtlas('chara', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', "chara0", 24, false);
				animation.addByPrefix('singUP', 'chara up0', 24, false);
				animation.addByPrefix('singDOWN', 'chara down0', 24, false);
				animation.addByPrefix('singLEFT', 'chara left0', 24, false);
				animation.addByPrefix('singRIGHT', 'chara right0', 24, false);

				animation.addByPrefix('zave', 'chara zave0', 24, false);
				animation.addByPrefix('zrick', 'chara zrick0', 24, true);

				/*addOffset('idle');
				addOffset("singUP", 0, 3);
				addOffset("singRIGHT", 0, 4);
				addOffset("singLEFT", -1, -1);
				addOffset("singDOWN", 12, -8);
				addOffset("zrick");
				addOffset("zave", -2, 0);*/

				loadOffset(curCharacter);

				playAnim('idle');

			case "crewmate":
				tex = Paths.getSparrowAtlas('crewmate', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', "impostor idle0", 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down0', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left0', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right0', 24, false);

				/*addOffset('idle');
				addOffset("singUP", 127, 110);
				addOffset("singRIGHT", 36, -12);
				addOffset("singLEFT", 212, -1);
				addOffset("singDOWN", 160, -28);*/

				loadOffset(curCharacter);
	
				playAnim('idle');
			
			case 'whitty': // whitty reg (lofight,overhead)
				tex = Paths.getSparrowAtlas('WhittySprites', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);

				/*addOffset('idle', 0, 0);
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);*/

				loadOffset(curCharacter);
			
			case 'sonicfun':
				tex = Paths.getSparrowAtlas('SonicFunAssets', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'SONICFUNIDLE', 24);
				animation.addByPrefix('singUP', 'SONICFUNUP', 24);
				animation.addByPrefix('singRIGHT', 'SONICFUNRIGHT', 24);
				animation.addByPrefix('singDOWN', 'SONICFUNDOWN', 24);
				animation.addByPrefix('singLEFT', 'SONICFUNLEFT', 24);

				/*addOffset('idle', -21, 66);
				addOffset("singUP", 21, 70);
				addOffset("singRIGHT", -86, 15);
				addOffset("singLEFT", 393, -60);
				addOffset("singDOWN", 46, -80);*/

				loadOffset(curCharacter);

				playAnim('idle');

			case 'glitched-bob':
				tex = Paths.getSparrowAtlas('ScaryBobAaaaah', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', "idle???-", 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				playAnim('idle');

			case 'sonic.exe':
				frames = Paths.getSparrowAtlas('P2Sonic_Assets', "shared", true);
				animation.addByPrefix('idle', 'NewPhase2Sonic Idle instance 1', 24, false);
				animation.addByPrefix('singUP', 'NewPhase2Sonic Up instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'NewPhase2Sonic Down instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'NewPhase2Sonic Left instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'NewPhase2Sonic Right instance 1', 24, false);
				animation.addByPrefix('laugh', 'NewPhase2Sonic Laugh instance 1', 24, false);

				loadOffset(curCharacter);

				playAnim('idle');
			
			case 'sonic.exe alt':
				frames = Paths.getSparrowAtlas('Sonic_EXE_Pixel', "shared", true);
				animation.addByPrefix('idle', 'Sonic_EXE_Pixel idle', 24, false);
				animation.addByPrefix('singUP', 'Sonic_EXE_Pixel NOTE UP', 24, false);
				animation.addByPrefix('singDOWN', 'Sonic_EXE_Pixel Sonic_EXE_Pixel NOTE DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Sonic_EXE_Pixel Sonic_EXE_Pixel NOTE LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Sonic_EXE_Pixel NOTE RIGHT', 24, false);

				loadOffset(curCharacter);

				antialiasing = false;

				playAnim('idle');

				setGraphicSize(Std.int(width * 12));
				updateHitbox();
			
			case 'beast':
				frames = Paths.getSparrowAtlas('Beast', "shared", true);
				animation.addByPrefix('idle', 'Beast_IDLE', 24, false);
				animation.addByPrefix('singUP', 'Beast_UP', 24, false);
				animation.addByPrefix('singDOWN', 'Beast_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Beast_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Beast_RIGHT', 24, false);
				animation.addByPrefix('laugh', 'Beast_LAUGH', 24, false);

				loadOffset(curCharacter);

				playAnim('idle');

			case 'knucks':
				tex = Paths.getSparrowAtlas('KnucklesEXE', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'Knux Idle', 24);
				animation.addByPrefix('singUP', 'Knux Up', 24);
				animation.addByPrefix('singRIGHT', 'Knux Left', 24);
				animation.addByPrefix('singDOWN', 'Knux Down', 24);
				animation.addByPrefix('singLEFT', 'Knux Right', 24);

				loadOffset(curCharacter);

			case 'tails':
				tex = Paths.getSparrowAtlas('Tails', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'Tails IDLE', 24);
				animation.addByPrefix('singUP', 'Tails UP', 24);
				animation.addByPrefix('singRIGHT', 'Tails RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Tails DOWN', 24);
				animation.addByPrefix('singLEFT', 'Tails LEFT', 24);

				loadOffset(curCharacter);
				setGraphicSize(Std.int(width * 1.2));

				updateHitbox();

			case 'egg':
				tex = Paths.getSparrowAtlas('eggman_soul', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'Eggman_Idle', 24);
				animation.addByPrefix('singUP', 'Eggman_Up', 24);
				animation.addByPrefix('singRIGHT', 'Eggman_Right', 24);
				animation.addByPrefix('singDOWN', 'Eggman_Down', 24);
				animation.addByPrefix('singLEFT', 'Eggman_Left', 24);
				animation.addByPrefix('laugh', 'Eggman_Laugh', 35, false);

				loadOffset(curCharacter);

				updateHitbox();

			case 'bfTT':
				var tex = Paths.getSparrowAtlas('BFPhase3_Perspective_Flipped', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'Idle_Flip', 24, false);
				animation.addByPrefix('singUP', 'Sing_Up_Flip', 24, false);
				animation.addByPrefix('singLEFT', 'Sing_Left_Flip', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing_Right_Flip', 24, false);
				animation.addByPrefix('singDOWN', 'Sing_Down_Flip', 24, false);
				animation.addByPrefix('singUPmiss', 'Up_Miss_Flip', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Left_Miss_Flip', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Right_Miss_Flip', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Down_Miss_Flip', 24, false);

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bfgb':
				var tex = Paths.getSparrowAtlas('BFLand', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);
				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, true);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm', 24, false);

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;

				scale.set(2.8, 2.8);
				updateHitbox();

				antialiasing = false;

			case 'bb':
				tex = Paths.getSparrowAtlas('bb', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'bb idle0', 24, false);
				animation.addByPrefix('singUP', 'bb up0', 24, false);
				animation.addByPrefix('singRIGHT', 'bb left0', 24, false);
				animation.addByPrefix('singDOWN', 'bb down0', 24, false);
				animation.addByPrefix('singLEFT', 'bb right0', 24, false);

				loadOffset(curCharacter);

				updateHitbox();

				flipX = true;

			case 'bfGfDEAD':
				
				frames = Paths.getSparrowAtlas('bfHoldingGF-DEAD', 'shared', true);
				animation.addByPrefix('deathLoop', 'BF Dead with GF Loop0', 24, false);
				animation.addByPrefix('firstDeath', 'BF Dies with GF0', 24, false);
				animation.addByPrefix('deathConfirm', 'RETRY confirm holding gf0', 24, false);

				loadOffset(curCharacter);

				playAnim('idle');

				flipX = true;

			case "xgaster": 
				frames = Paths.getSparrowAtlas('xgaster1', 'shared', true);
				animation.addByPrefix("idle", "Xgaster idle dance0", 24);
				animation.addByPrefix("singLEFT", "Xgaster Sing Note LEFT0", 24, false);
				animation.addByPrefix("singUP", "Xgaster Sing Note UP0", 24, false);

				playAnim("idle");

			case "xgaster2": 
				frames = Paths.getSparrowAtlas('xgaster2', 'shared', true);
		
				animation.addByPrefix("singRIGHT", "Xgaster Sing Note RIGHT0", 24, false);
				animation.addByPrefix("singDOWN", "Xgaster Sing Note DOWN0", 24, false);
			
			case "edd": 
				frames = Paths.getSparrowAtlas("edd", "shared", true);

				animation.addByPrefix("idle", "EddIdle0", 24, false);
				animation.addByPrefix("singUP", "EddUp0", 24, false);
				animation.addByPrefix("singDOWN", "EddDown0", 24, false);
				animation.addByPrefix("singLEFT", "EddLeft0", 24, false);
				animation.addByPrefix("singRIGHT", "EddRight0", 24, false);
				
				animation.addByPrefix("HEY", "EddHEY!!0", 24, false);
				animation.addByPrefix("turn", "EddTurnAround0", 24, false);

				loadOffset(curCharacter);

				playAnim("idle");

			case "edd-alt": 
				frames = Paths.getSparrowAtlas("edd", "shared", true);

				flipX = true;
				
				animation.addByPrefix("idle", "EddSideIdle0", 24, false);
				animation.addByPrefix("singUP", "EddSideUp0", 24, false);
				animation.addByPrefix("singDOWN", "EddSideDown0", 24, false);
				animation.addByPrefix("singLEFT", "EddSideLeft0", 24, false);
				animation.addByPrefix("singRIGHT", "EddSideRight0", 24, false);

				loadOffset(curCharacter);

				playAnim("idle");

			case "eduardo": 
				frames = Paths.getSparrowAtlas("eduardo", "shared", true);

				animation.addByPrefix("idle", "EduardoIdle0", 24, false);
				animation.addByPrefix("singUP", "EduardoUp0", 24, false);
				animation.addByPrefix("singDOWN", "EduardoDown0", 24, false);
				animation.addByPrefix("singLEFT", "EduardoLeft0", 24, false);
				animation.addByPrefix("singRIGHT", "EduardoRight0", 24, false);
				
				animation.addByPrefix("well", "EduardoWell0", 24, false);

				loadOffset(curCharacter);

				playAnim("idle");

			case 'exe':
				tex = Paths.getSparrowAtlas('Exe_Assets', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'Exe Idle', 24, false);
				animation.addByPrefix('singUP', 'Exe Up', 24);
				animation.addByPrefix('singRIGHT', 'Exe Right', 24);
				animation.addByPrefix('singDOWN', 'Exe Down', 24);
				animation.addByPrefix('singLEFT', 'Exe left', 24);

				loadOffset(curCharacter);

				playAnim("idle");

			case 'hypno_MX':
				tex = Paths.getSparrowAtlas('hypno_MX', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'MXIdle0', 24, false);
				animation.addByPrefix('singUP', 'MXUp0', 24);
				animation.addByPrefix('singRIGHT', 'MXRight0', 24);
				animation.addByPrefix('singDOWN', 'MXDown0', 24);
				animation.addByPrefix('singLEFT', 'MXLeft0', 24);

				animation.addByPrefix('idk', 'MXHit1', 24);
				animation.addByPrefix('idk2', 'MXHit2', 24, false);

				loadOffset(curCharacter);

				setGraphicSize(Std.int(width / 1.3));

				playAnim("idle");
			
			case 'lord-x':
				tex = Paths.getSparrowAtlas('GAMBLE_X', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'X IDLE0', 24, false);
				animation.addByPrefix('singUP', 'X UP0', 24);
				animation.addByPrefix('singRIGHT', 'X LEFT0', 24);
				animation.addByPrefix('singDOWN', 'X DOWN0', 24);
				animation.addByPrefix('singLEFT', 'X RIGHT0', 24);

				flipX = true;

				loadOffset(curCharacter);

				playAnim("idle");

			case 'hypno':
				tex = Paths.getSparrowAtlas('Hypno_Shit', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'Hypno2 Idle0', 24);
				animation.addByPrefix('singUP', 'Hypno Up Finished0', 24);
				animation.addByPrefix('singRIGHT', 'Hypno Right Finished0', 24);
				animation.addByPrefix('singDOWN', 'Hypno Down0', 24);
				animation.addByPrefix('singLEFT', 'Hypno Left final0', 24);

				flipX = true;

				loadOffset(curCharacter);

				playAnim("idle");

			case 'hate-you':
				tex = Paths.getSparrowAtlas('Luigi_IHY', "shared", true);
				frames = tex;
				animation.addByPrefix('idle', 'LuigiIdle0', 24, false);
				animation.addByPrefix('singUP', 'LuigiUp0', 24, false);
				animation.addByPrefix('singRIGHT', 'LuigiRight0', 24, false);
				animation.addByPrefix('singDOWN', 'LuigiDown0', 24, false);
				animation.addByPrefix('singLEFT', 'LuigiLeft0', 24, false);

				loadOffset(curCharacter);

				playAnim("idle");

			case "MarioLand": 
				tex = Paths.getSparrowAtlas("MarioLand", "shared", true); 
				frames = tex; 
				animation.addByPrefix("idle", "MBIdle0", 24, false); 
				animation.addByPrefix('singUP', 'MBUp0', 24, false);
				animation.addByPrefix('singRIGHT', 'MBRight0', 24, false);
				animation.addByPrefix('singDOWN', 'MBDown0', 24, false);
				animation.addByPrefix('singLEFT', 'MBLeft0', 24, false);

				loadOffset(curCharacter);

				playAnim("idle");
				scale.set(2.8, 2.8);
				updateHitbox();

				antialiasing = false;

			case "MarioLandCrazy": 
				tex = Paths.getSparrowAtlas("MarioLand", "shared", true); 
				frames = tex; 
				animation.addByPrefix("idle", "GBIdleCrazy0", 24, false); 
				animation.addByPrefix('singUP', 'GBUpCrazy0', 24, false);
				animation.addByPrefix('singRIGHT', 'GBRightCrazy0', 24, false);
				animation.addByPrefix('singDOWN', 'GBDownCrazy0', 24, false);
				animation.addByPrefix('singLEFT', 'GBLeftCrazy0', 24, false);
				animation.addByPrefix("laugh", "GBLaugh0", 32, false);

				loadOffset(curCharacter);

				playAnim("idle");
				scale.set(2.8, 2.8);
				updateHitbox();

				antialiasing = false;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffset(character:String)
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt('images/characters/offsets/' + character + "Offsets", 'shared'));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	/*public function loadMappedAnims()
	{

		var a = Paths.loadFromJson("picospeaker", "stress");
		for (i in a.notes) 
		{
            var c = a[];
            ++b;
            var d = 0;
            for (f in sectionNotes) 
			{
                var e = c[d];
                ++d;
                animationNotes.push(e);
            }
		}
	}*/

	override function update(elapsed:Float)
	{
		if (!isBf && curCharacter != "xgaster2")
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{	
			if (doubleAnim)
			{
				if (!animation.curAnim.name.startsWith('hair'))
				{
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				}
			}else 
			{
				playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
