package pixeldroid.util.log
{

    import system.platform.File;

    /**
        Provides a simple message limited file logger for use by Log.

        Log messages are written to file via `system.platform.File`, which requires
        a full file write each time (there is no write-append method for `File`). To
        prevent memory overflow, the printer stores a limited number of messages,
        replacing oldest ones with newest ones when the limit is reached.

        @see system.platform.File#writeTextFile
    */
    class FilePrinter implements Printer
    {
        private var data:Vector.<String> = [];
        private var _logfile:String = 'logfile.log';
        private var _messageLimit:Number = 200;


        public function print(message:String):void
        {
            data.push(message);
            if (data.length > _messageLimit) data.shift();
            save();
        }

        /**
            Add on to the latest existing message.

            If called before any message has been logged, `append()` will function as `print()`.

            @param message String to be appended to end of latest existing message
        */
        public function append(message:String):void
        {
            var n:Number = data.length - 1;
            if (n < 1) print(message);
            else
            {
                data[n] += ' ' +message;
                save();
            }
        }

        /**
            Replace the latest existing message.

            If called before any message has been logged, `replace()` will function as `print()`.

            @param message String to overwrite latest existing message
        */
        public function replace(message:String):void
        {
            var n:Number = data.length - 1;
            if (n < 1) print(message);
            else
            {
                data[n] = message;
                save();
            }
        }

        /**
            Specify the maximum number of messages to buffer and write.
        */
        public function set messageLimit(limit:Number):void
        {
            _messageLimit = Math.max(0, limit);
            while (data.length > _messageLimit) data.shift();
        }
        public function get messageLimit():Number { return _messageLimit; }

        /**
            Specify the path of the logfile to use.

            The logfile will be created if it doesn't already exist.

            @param filepath Path to logfile (full or relative to default writeable directory)
            @return `false` if the file cannot be written to
        */
        public function setLogfile(filepath:String):Boolean
        {
            _logfile = filepath;
            data.push('setting logfile to "' +_logfile +'"');

            return save();
        }

        /**
            Retrieve the current path to the logfile.
        */
        public function get logfile():String { return _logfile; }


        private function save():Boolean
        {
            return File.writeTextFile(_logfile, data.join('\n') + '\n');
        }
    }
}
