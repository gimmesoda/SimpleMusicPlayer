import hxd.Event;
import h2d.Bitmap;
import hxd.snd.Channel;
import hxd.Key;
import haxe.io.Path;
import hxd.Res;
import h2d.Tile;
import MusicLoader.LoadedMusic;
import hxd.App;

using Lambda;

class Main extends App {
	private static function main() {
		new Main();
	}

	private var musicItems:Array<MusicItem> = [];
	private var currentItem:Int = 0;

	private var prevChannel:Null<Channel>;
	private var currChannel:Null<Channel>;

	private var background:Bitmap;
	private var controls:Controls;

	override function init() {
		Res.initLocal();
		MusicLoader.loadAllMusic();

		s2d.renderer.defaultSmooth = true;

		background = new Bitmap(Tile.fromColor(0xff000000), s2d);

		background.filter = new h2d.filter.Shader<BackgroundShader>(new BackgroundShader());
	
		controls = new Controls((e:Event) -> changeItem(-1), (e:Event) -> {
			if (currChannel != null) currChannel.pause = !currChannel.pause;
			controls.animatePlayPause();
			controls.playPause.tile = currChannel?.pause == false ? Res.controls.pause.toTile() : Res.controls.play.toTile();
		}, (e:Event) -> changeItem(1), /*s2d*/);

		onResize();
	}

	override function onResize() {
		background.width = s2d.width;
		background.height = s2d.height;

		controls.setPosition((s2d.width - controls.getBounds().width) * 0.5, s2d.height - 100);
	}

	override function update(dt:Float) {
		while (MusicLoader.loadedQueue.length > 0) {
			final music:LoadedMusic = MusicLoader.loadedQueue.shift();
			
			final thumbnailTile:Tile = Res.placeholder.toTile();
			final songName:String = Path.withoutExtension(music.entry.name);

			final item:MusicItem = new MusicItem(thumbnailTile, songName, s2d);
			item.sound = music.sound;
			item.y = (s2d.height * 0.5) - 100;
			musicItems.push(item);

			if (musicItems.length == 1) changeItem(0);
		}

		var deltaItem:Int = 0;
		if ([Key.LEFT, Key.MOUSE_WHEEL_UP].exists(Key.isPressed)) deltaItem--;
		if ([Key.RIGHT, Key.MOUSE_WHEEL_DOWN].exists(Key.isPressed)) deltaItem++;

		if (deltaItem != 0) changeItem(deltaItem);

		if (Key.isPressed(Key.SPACE)) {
			if (currChannel != null) currChannel.pause = !currChannel.pause;
			controls.animatePlayPause();
			controls.playPause.tile = currChannel?.pause == false ? Res.controls.pause.toTile() : Res.controls.play.toTile();
		}

		if (musicItems.length == 0) return;

		for (i => item in musicItems) {
			final isCurrent:Bool = i == currentItem;

			final targetAlpha:Float = isCurrent ? 1 : 0.4;

			final startX:Float = Math.min(s2d.width * 0.5, 400) - 100;
			final targetX:Float = startX + (i - currentItem) * 220;

			item.alpha = hxd.Math.lerpTime(item.alpha, targetAlpha, 0.16, dt);
			item.x = hxd.Math.lerpTime(item.x, targetX, 0.16, dt);
		}
	}

	private function changeItem(delta:Int) {
		if (delta < 0) controls.animateBack();
		else if (delta > 0) controls.animateNext();

		currentItem += delta;
		while (currentItem < 0) currentItem += musicItems.length;
		while (currentItem >= musicItems.length) currentItem -= musicItems.length;

		prevChannel?.stop();

		prevChannel = currChannel;
		prevChannel?.fadeTo(0, 0.5, () -> prevChannel.stop());
		
		currChannel = musicItems[currentItem]?.sound?.play(true, 0);
		currChannel?.fadeTo(1, 0.5);
	}
}