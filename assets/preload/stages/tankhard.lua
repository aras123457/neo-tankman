-- Lua stuff
tankX = 400;
tankSpeed = 0;
tankAngle = 0;
finishedGameover = false;
startedPlaying = false;

function onCreate()
	-- background shit
	math.randomseed(os.time());
	tankSpeed = math.random(5, 7);
	tankAngle = math.random(-90, 45);
	makeLuaSprite('tankSky2', 'tankSky2', -400, -400);
	setLuaSpriteScrollFactor('tankSky2', 0, 0);

	makeLuaSprite('tankBuildings', 'tankBuildings', -200, 0);
	setLuaSpriteScrollFactor('tankBuildings', 0.3, 0.3);
	setGraphicSize('tankBuildings', 1.1, 1.1);

	makeLuaSprite('tankRuins', 'tankRuins', -200, 0);
	setLuaSpriteScrollFactor('tankRuins', 0.35, 0.35);
	setGraphicSize('tankRuins', 1.1, 1.1);

	makeAnimatedLuaSprite('tankWatchtower', 'tankWatchtower', 100, 50);
	luaSpriteAddAnimationByPrefix('tankWatchtower', 'idle', 'watchtower', 24, false);
	setLuaSpriteScrollFactor('tankWatchtower', 0.5, 0.5);

	makeAnimatedLuaSprite('tankRolling', 'tankRolling', 300, 300);
	luaSpriteAddAnimationByPrefix('tankRolling', 'idle', 'BG tank w lighting', 24, true);
	setLuaSpriteScrollFactor('tankRolling', 0.5, 0.5);

	makeLuaSprite('tankGround', 'tankGround', -420, -150);
	setGraphicSize('tankGround', 1.15, 1.15);
	
	-- those are only loaded if you have Low quality turned off, to decrease loading times and memory
	if not lowQuality then
		makeLuaSprite('tankClouds', 'tankClouds', math.random(-700, -100), math.random(-20, 20));
		setLuaSpriteScrollFactor('tankClouds', 0.1, 0.1);
		setProperty('tankClouds.velocity.x', math.random(5, 15));

		makeLuaSprite('tankMountains', 'tankMountains', -300, -20);
		setLuaSpriteScrollFactor('tankMountains', 0.2, 0.2);
		setGraphicSize('tankMountains', 1.2, 1.2);

	end

	addLuaSprite('tankSky2', false);
	addLuaSprite('tankClouds', false);
	addLuaSprite('tankMountains', false);
	addLuaSprite('tankBuildings', false);
	addLuaSprite('tankRuins', false);
	addLuaSprite('smokeLeft', false);
	addLuaSprite('smokeRight', false);
	addLuaSprite('tankWatchtower', false);
	addLuaSprite('tankRolling', false);
	addLuaSprite('tankGround', false);


end

function onUpdate(elapsed)
	moveTank(elapsed);
	
	if inGameOver and not startedPlaying and not finishedGameover then
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0.2);
	end
end

function moveTank(elapsed)
	if not inCutscene then
		tankAngle = tankAngle + (elapsed * tankSpeed);
		setProperty('tankRolling.angle', tankAngle - 90 + 15);
		setProperty('tankRolling.x', tankX + (1500 * math.cos(math.pi / 180 * (1 * tankAngle + 180))));
		setProperty('tankRolling.y', 1300 + (1100 * math.sin(math.pi / 180 * (1 * tankAngle + 180))));
	end
end

-- Gameplay/Song interactions
function onBeatHit()
	-- triggered 4 times per section
	luaSpritePlayAnimation('tankWatchtower', 'idle', false);
	luaSpritePlayAnimation('tank0', 'idle', false);
	luaSpritePlayAnimation('tank1', 'idle', false);
	luaSpritePlayAnimation('tank2', 'idle', false);
	luaSpritePlayAnimation('tank3', 'idle', false);
	luaSpritePlayAnimation('tank4', 'idle', false);
	luaSpritePlayAnimation('tank5', 'idle', false);
end

function onCountdownTick(counter)
	onBeatHit();
end


-- Game over voiceline
function onGameOver()
	runTimer('playJeffVoiceline', 2.7);
	return Function_Continue;
end

function onGameOverConfirm(reset)
	finishedGameover = true;
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A tween you called has been completed, value "tag" is it's tag
	if not finishedGameover and tag == 'playJeffVoiceline' then
		math.randomseed(os.time());
		soundName = string.format('jeffGameover/jeffGameover-%i', math.random(1, 25));
		playSound(soundName, 1, 'voiceJeff');
		startedPlaying = true;
	end
end

function onSoundFinished(tag)
	if tag == 'voiceJeff' and not finishedGameover then
		soundFadeIn(nil, 4, 0.2, 1);
	end
end