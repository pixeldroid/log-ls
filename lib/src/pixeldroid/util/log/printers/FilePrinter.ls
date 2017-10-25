package pixeldroid.util.log.printers
{

    import system.platform.File;

    import pixeldroid.util.log.Printer;

    /**
        Provides a file logger with a fixed buffer size for use by `Log`.

        Log messages are written to file via `system.platform.File`, which requires
        a full file write each time (there is no write-append method for `File`). To
        prevent memory overflow, the printer stores a limited number of messages in a buffer,
        replacing oldest ones with newest ones when the limit is reached (first in, last out).

        Messages can be appended to or replaced. The buffer is written to disk after each print operation.

        @see system.platform.File#writeTextFile
    */
    class FilePrinter implements Printer
    {
        private var _logfile:String = 'logfile.log';
        private var _messageLimit:Number = 200;

        /**
        The message buffer.

        Number of messages stored in the buffer is capped by `messageLimit`.

        @see #messageLimit
        */
        protected var data:Vector.<String> = [];


        /** @copy pixeldroid.util.log.Printer */
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
            if (n < 0) print(message);
            else
            {
                data[n] = data[n] +' ' +message;
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
            if (n < 0) print(message);
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


        /**
        Write the current message queue to disk.

        Called after each `print()`, `append()`, or `replace()` operation.

        @return `true` on write success, `false` on error.
        */
        protected function save():Boolean
        {
            return File.writeTextFile(_logfile, data.join('\n') + '\n');
        }
    }
}
