package pixeldroid.util
{
    /**
        Enumerates the verbosity levels of the logging system, from `NONE` (least verbose) to `DEBUG` (most verbose).

        The order of increasing verbosity is: `NONE` > `FATAL` > `ERROR` > `WARN` > `INFO` > `DEBUG`.

        * `NONE` indicates no logging should occur.
        * `FATAL` allows only messages related to application crashes.
        * `ERROR` adds messages related to unexpected results that will break expected behavior.
        * `WARN` adds messages related to unexpected results that will not break expected behavior.
        * `INFO` adds messages that track happy path execution.
        * `DEBUG` adds messages that track program state.

        All LogLevel values have both a human readable string value (`label`), as well as a machine-comparable numeric value (`value`).
    */
    class LogLevel
    {
        public static const NONE:LogLevel = new LogLevel(0, 'NONE');
        public static const FATAL:LogLevel = new LogLevel(1, 'FATAL');
        public static const ERROR:LogLevel = new LogLevel(2, 'ERROR');
        public static const WARN:LogLevel = new LogLevel(3, 'WARN');
        public static const INFO:LogLevel = new LogLevel(4, 'INFO');
        public static const DEBUG:LogLevel = new LogLevel(5, 'DEBUG');

        /**
            Create a LogLevel instance from a label.

            @param value A string matching one of [NONE, FATAL, ERROR, WARN, INFO, DEBUG]
        */
        public static function fromString(value:String):LogLevel
        {
            switch (value.toUpperCase())
            {
                case 'NONE' : return NONE;
                case 'FATAL': return FATAL;
                case 'ERROR': return ERROR;
                case 'WARN' : return WARN;
                case 'INFO' : return INFO;
                case 'DEBUG': return DEBUG;
            }
            return NONE;
        }

        /**
            Test for interchangeablility between LogLevel instances.

            Two different instantiations of LogLevel will not formally equate to each other,
            but can be considered equivalent if they represent the same log level.

            This method is a convenience for testing that value and label are the same on both instances.

            @param a An instance of LogLevel
            @param b An instance of LogLevel to compare against instance a
        */
        public static function areEquivalent(a:LogLevel, b:LogLevel):Boolean
        {
            if (a.value != b.value) return false;
            if (a.label != b.label) return false;
            return true;
        }


        private var _level:Number;
        private var _label:String;

        public function LogLevel(level:Number, label:String)
        {
            _level = level;
            _label = label;
        }

        /**
            Request a human-readable representation of the logging level.

            This is equivalent to the label.
        */
        public function toString():String { return _label; }

        /**
            Request a string representation of the logging level.
        */
        public function get label():String { return _label; }

        /**
            Request a numerical representation of the logging level.

            Level values can be compared to each other, with higher values being more verbose.
        */
        public function get value():Number { return _level; }
    }
}
