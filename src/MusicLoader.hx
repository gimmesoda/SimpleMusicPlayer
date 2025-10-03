import hxd.fs.LocalFileSystem;
import hxd.fs.FileSystem;
import sys.thread.Thread;
import hxd.fs.FileEntry;
import hxd.res.Sound;

typedef LoadedMusic = {entry:FileEntry, sound:Sound}

class MusicLoader {
	public static var loadedQueue:Array<LoadedMusic> = [];

	public static function loadAllMusic() {
		trace('[INFO] Creating local filesystem...');
		final fs:FileSystem = new LocalFileSystem('music', null);

		Thread.create(() -> {
			final entries:Array<FileEntry> = fs.dir('./');
			for (e in entries) {
				loadedQueue.push({entry: e, sound: new Sound(e)});
				trace('[INFO] Loaded song ${e.name}');
			}
		});
	}
}