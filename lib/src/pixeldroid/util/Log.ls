package pixeldroid.util
{
    /**
        Enumerates the verbosity levels of the logging system, from `NONE` (least verbose) to `DEBUG` (most verbose).

        The order of increasing verbosity is: `NONE` < `FATAL` < `ERROR` < `WARN` < `INFO` < `DEBUG`.

        * `NONE` indicates no logging should occur.
        * `FATAL` allows only messages related to application crashes.
        * `ERROR` adds messages related to unexpected results that will break expected behavior.
        * `WARN` adds messages related to unexpected results that will not break expected behavior.
        * `INFO` adds messages that track happy path execution.
        * `DEBUG` adds messages that track program state.

        Use Log.levelToString() to retrieve a text representation of the level.

        @see Log#levelToString
        @see Log#levelFromString
    */
    enum LogLevel
    {
        NONE, // 0
        FATAL,
        ERROR,
        WARN,
        INFO,
        DEBUG
    }

    /**
        Provides methods for sending formatted log messages at various verbosity levels.

        Messages that exceed the current verbosity threshold stored in `level` will be ignored.

        A default formatter is provided. Custom formatters can be used by setting
        the value of the `formatter` property to a Formatter-compliant class instance.

        A default printer is provided to log to `Console.print()`. Custom printers
        can be used by setting the value of the `printer` property to a Printer-
        compliant class instance.

        Logging functions expect a label to indicate the owner of the message, and
        a function that should evaluate to a message when called. By capturing the
        message construction in a closure, any costs associated with forming the message
        are avoided for logging calls above the current verbosity threshold (log level).
    */
    class Log
    {
        public static const version:String = '1.0.1';

        public static const defaultFormatter:Formatter = new BasicFormatter();
        public static const defaultPrinter:Printer = new ConsolePrinter();
        public static const defaultLevel:LogLevel = LogLevel.ERROR;

        public static var formatter:Formatter = defaultFormatter;
        public static var printer:Printer = defaultPrinter;
        public static var level:LogLevel = defaultLevel;

        /**
            Submit a message at debug level verbosity (the highest verbosity level).

            DEBUG messages help isolate problems in running systems, by showing
            what is being executed and the execution context.

            DEBUG messages should provide context that makes it easy to spot
            abnormal values or conditions.

            @param label Name of the message owner
            @param messageGenerator A function to generate the message string
        */
        public static function debug(label:String, messageGenerator:Function):void
        {
            if (level >= LogLevel.DEBUG) processMessage(LogLevel.DEBUG, label, messageGenerator);
        }

        /**
            Submit a message at info level verbosity

            INFO messages announce--at a high level--what the running system is doing.
            The system should be able to run at full speed with INFO level logging.

            INFO messages should paint a clear picture of normal system operation.

            @param label Name of the message owner
            @param messageGenerator A function to generate the message string
        */
        public static function info(label:String, messageGenerator:Function):void
        {
            if (level >= LogLevel.INFO) processMessage(LogLevel.INFO, label, messageGenerator);
        }

        /**
            Submit a message at warn level verbosity

            WARN messages signal that something unexpected has occurred; the system
            is still operating as expected, but some investigation may be warranted.

            WARN messages should be clear about what expectation was invalidated.

            @param label Name of the message owner
            @param messageGenerator A function to generate the message string
        */
        public static function warn(label:String, messageGenerator:Function):void
        {
            if (level >= LogLevel.WARN) processMessage(LogLevel.WARN, label, messageGenerator);
        }

        /**
            Submit a message at error level verbosity.

            ERROR messages record that something has gone wrong, the system is unable
            to recover, and an operator needs to investigate and fix something.

            ERROR messages should be clear about what went wrong and how it can be triaged or fixed.

            @param label Name of the message owner
            @param messageGenerator A function to generate the message string
        */
        public static function error(label:String, messageGenerator:Function):void
        {
            if (level >= LogLevel.ERROR) processMessage(LogLevel.ERROR, label, messageGenerator);
        }

        /**
            Submit a message at fatal level verbosity.

            FATAL messages document a failure that prevents the system from starting,
            and indicate the system is completely unusable.

            FATAL messages should be clear about what assertion was violated.

            @param label Name of the message owner
            @param messageGenerator A function to generate the message string
        */
        public static function fatal(label:String, messageGenerator:Function):void
        {
            if (level >= LogLevel.FATAL) processMessage(LogLevel.FATAL, label, messageGenerator);
        }

        /**
            Convert a log level enumeration into a human-readable string.

            @param value A verbosity enumeration from LogLevel
        */
        public static function levelToString(value:LogLevel):String
        {
            switch (value)
            {
                case LogLevel.NONE : return 'NONE';
                case LogLevel.FATAL: return 'FATAL';
                case LogLevel.ERROR: return 'ERROR';
                case LogLevel.WARN : return 'WARN';
                case LogLevel.INFO : return 'INFO';
                case LogLevel.DEBUG: return 'DEBUG';
            }
            return 'NONE';
        }

        /**
            Convert a human-readable string into a log level enumeration.

            @param value A string matching one of [NONE, FATAL, ERROR, WARN, INFO, DEBUG]
        */
        public static function levelFromString(value:String):LogLevel
        {
            switch (value.toUpperCase())
            {
                case 'NONE' : return LogLevel.NONE;
                case 'FATAL': return LogLevel.FATAL;
                case 'ERROR': return LogLevel.ERROR;
                case 'WARN' : return LogLevel.WARN;
                case 'INFO' : return LogLevel.INFO;
                case 'DEBUG': return LogLevel.DEBUG;
            }
            return LogLevel.NONE;
        }


        private static function processMessage(level:LogLevel, label:String, messageGenerator:Function):void
        {
            // there is also Platform.getEpochTime(), but no Date object, so no conversion to YY, MM, DD, etc.
            // since time conversion accounting for leap years is non-trivial, we just use uptime here:
            var time:Number = Platform.getTime(); // milliseconds since app launch
            var message:String = messageGenerator() as String;
            printer.print(formatter.format(time, level, label, message));
        }
    }

    /**
        Declares a receiver function for use by the logger.
    */
    interface Printer
    {
        /**
            @param message The message to be printed to a log receiver
        */
        function print(message:String):void;
    }

    /**
        Declares a message formatting function for use by the logger.
    */
    interface Formatter
    {
        /**
            @param time The number of milliseconds since app start
            @param level A `LogLevel` constant representing verbosity of the message
            @param label A name for the owner of the message
            @param message The message to be logged
        */
        function format(time:Number, level:LogLevel, label:String, message:String):String;
    }


    class ConsolePrinter implements Printer
    {
        public function print(message:String):void
        {
            Console.print(message);
        }
    }

    class BasicFormatter implements Formatter
    {
        public function format(time:Number, level:LogLevel, label:String, message:String):String
        {
            var h:Number = Math.floor(time / (60 * 60 * 1000));
            time -= h * (60 * 60 * 1000);
            var m:Number = Math.floor(time / (60 * 1000));
            time -= m * (60 * 1000);
            var s:Number = Math.floor(time / 1000);
            time -= s * 1000;
            var l:Number = time;

            var hh:String = String.lpad(h.toString(), '0', 2);
            var mm:String = String.lpad(m.toString(), '0', 2);
            var ss:String = String.lpad(s.toString(), '0', 2);
            var ll:String = String.lpad(l.toString(), '0', 3);

            return hh +':' + mm + ':' + ss + '.' + ll + ' [' + String.lpad(Log.levelToString(level), ' ', 5) + '] ' + label + ': ' + message;
        }
    }
}
