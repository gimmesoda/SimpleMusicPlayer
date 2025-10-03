import h2d.filter.Glow;
import hxd.res.Sound;
import h2d.Object;
import h2d.Tile;
import h2d.Flow;

class MusicItem extends Flow implements h2d.domkit.Object {
	private static final SRC = <music-item layout="vertical">
		<bitmap tile={thumbnailTile} height="200" id="thumbnail"/>
		<text text={musicName} scale="2"/>
	</music-item>

	public var sound:Sound;

	public function new(thumbnailTile:Tile, musicName:String, ?parent:Object) {
		super(parent);
		initComponent();

		thumbnail.filter = new Glow(0xffffffff, 1, 10, 1, 1, true);
	}
}