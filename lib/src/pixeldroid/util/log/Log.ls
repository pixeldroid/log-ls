package pixeldroid.util.log
{

    import pixeldroid.util.log.formatters.BasicFormatter;
    import pixeldroid.util.log.printers.ConsolePrinter;
    import pixeldroid.util.log.Formatter;
    import pixeldroid.util.log.LogLevel;
    import pixeldroid.util.log.Printer;

    /**
        Provides methods for sending formatted log messages at various verbosity levels.

        Messages that exceed the current verbosity threshold stored in `level` will be ignored.
        The default level is `INFO` (allowing `INFO`, `WARN`, `ERROR`, and `FATAL` messages, but
        not `DEBUG`).

        A default formatter is provided. Custom formatters can be used by setting
        the value of the `formatter` property to a `Formatter`-compliant class instance.

        A default printer is provided to log to `Console.print()`. Custom printers
        can be used by setting the value of the `printer` property to a `Printer`-compliant
        class instance.

        Logging functions expect a label to indicate the owner of the message, and
        a function that should evaluate to a message when called. By capturing the
        message construction in a closure, any costs associated with forming the message
        are avoided for logging calls above the current verbosity threshold (log level).

        @see pixeldroid.util.log.Formatter
        @see pixeldroid.util.log.Printer
    */
    final static class Log
    {
        /** Version of the Log library */
        public static const version:String = '3.0.0';

        /**
        Default formatter. Override by setting value of `formatter`
        @see #formatter
        */
        public static const defaultFormatter:Formatter = new BasicFormatter();

        /**
        Default printer. Override by setting value of `printer`
        @see #printer
        */
        public static const defaultPrinter:Printer = new ConsolePrinter();

        /**
        Default log level. Override by setting value of `level`
        @see #level
        */
        public static const defaultLevel:LogLevel = 4; // LogLevel.INFO // static initializer runs before member initialization of imported enum

        /** Current formatter in use. */
        public static var formatter:Formatter = defaultFormatter;

        /** Current printer in use. */
        public static var printer:Printer = defaultPrinter;

        /** Current log level. */
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

            @param value A verbosity enumeration from `LogLevel`
            @return A human readable string indicating the log level

            @see pixeldroid.util.log.LogLevel
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

            @param value A string matching one of [`NONE`, `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`]
            @return A LogLevel enumeration value

            @see pixeldroid.util.log.LogLevel
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
}
