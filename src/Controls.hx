import h2d.RenderContext;
import hxd.Event;
import h2d.Interactive;
import h2d.Object;
import hxd.Res;
import h2d.Flow;

class Controls extends Flow implements h2d.domkit.Object {
	private static final SRC = <controls spacing="10">
		<bitmap tile={Res.controls.back.toTile()} scale="0.1" id="back"/>
		<bitmap tile={Res.controls.pause.toTile()} scale="0.1" public id="playPause"/>
		<bitmap tile={Res.controls.next.toTile()} scale="0.1" id="next"/>
	</controls>

	public function new(onBack:(Event)->Void, onPlayPause:(Event)->Void, onNext:(Event)->Void, ?parent:Object) {
		super(parent);
		initComponent();

		final iback:Interactive = new Interactive(back.tile.width, back.tile.height, back);
		iback.onClick = onBack;

		final iplayPause:Interactive = new Interactive(playPause.tile.width, playPause.tile.height, playPause);
		iplayPause.onClick = onPlayPause;

		final inext:Interactive = new Interactive(next.tile.width, next.tile.height, next);
		inext.onClick = onNext;
	}

	public function animateBack() {
		back.alpha = 0.6;
	}

	public function animatePlayPause() {
		playPause.alpha = 0.6;
	}

	public function animateNext() {
		next.alpha = 0.6;
	}

	override function sync(ctx:RenderContext) {
		back.alpha = hxd.Math.lerpTime(back.alpha, 1, 0.16, ctx.elapsedTime);
		playPause.alpha = hxd.Math.lerpTime(playPause.alpha, 1, 0.16, ctx.elapsedTime);
		next.alpha = hxd.Math.lerpTime(next.alpha, 1, 0.16, ctx.elapsedTime);

		super.sync(ctx);
	}
}