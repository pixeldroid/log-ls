package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.Log;
    import pixeldroid.util.LogLevel;
    import pixeldroid.util.Printer;


    public static class LogSpec
    {
        private static const it:Thing = Spec.describe('Log');
        private static const testPrinter:TestPrinter = new TestPrinter();
        private static var initialLevel:LogLevel;

        public static function describe():void
        {
            before();

            it.should('be versioned', be_versioned);
            it.should('default to ERROR level logging', default_to_error);
            it.should('provide a default format for time, level, label, and message', provide_default_format);
            it.should('provide a set of increasing verbosity levels', provide_levels);
            it.should('not log messages more verbose than the current log level', ignore_higher_levels);
            it.should('not compute messages that are not logged', log_lazily);
        }


        private static function before():void
        {
            initialLevel = Log.level;
            Log.printer = testPrinter;
        }

        private static function be_versioned():void
        {
            it.expects(Log.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function default_to_error():void
        {
            it.expects(initialLevel).toEqual(LogLevel.ERROR);
            it.expects(initialLevel).toEqual(Log.defaultLevel);
        }

        private static function provide_default_format():void
        {
            var lastLevel:LogLevel = Log.level;
            Log.level = LogLevel.INFO;

            Log.info('LogSpec', function():String { return 'info message'; });

            // Loom uses Lua regex patterns:
            //   http://lua-users.org/wiki/PatternsTutorial
            //   http://www.lua.org/manual/5.2/manual.html#6.4.1
            var time:String = '^(%d%d:%d%d:%d%d.%d%d%d)';
            var level:String = '%s(%[%s?%u+%])';
            var label:String = '%s(.*:)';
            var message:String = '%s(.*)$';

            it.expects(testPrinter.lastMessage).toPatternMatch(time +level +label +message, 4);

            Log.level = lastLevel;
        }

        private static function provide_levels():void
        {
            it.expects(LogLevel.NONE ).toBeLessThan(LogLevel.FATAL);
            it.expects(LogLevel.FATAL).toBeLessThan(LogLevel.ERROR);
            it.expects(LogLevel.ERROR).toBeLessThan(LogLevel.WARN);
            it.expects(LogLevel.WARN ).toBeLessThan(LogLevel.INFO);
            it.expects(LogLevel.INFO ).toBeLessThan(LogLevel.DEBUG);
        }

        private static function ignore_higher_levels():void
        {
            var lastLevel:LogLevel = Log.level;

            Log.level = LogLevel.INFO;
            Log.warn('LogSpec', function():String { return 'warn message'; });
            it.expects(testPrinter.lastMessage).not.toBeEmpty();

            Log.debug('LogSpec', function():String { return 'debug message'; });
            it.expects(testPrinter.lastMessage).toBeEmpty();

            Log.level = LogLevel.NONE;
            Log.fatal('LogSpec', function():String { return 'fatal message'; });
            Log.error('LogSpec', function():String { return 'error message'; });
            Log.warn ('LogSpec', function():String { return 'warn message'; });
            Log.info ('LogSpec', function():String { return 'info message'; });
            Log.debug('LogSpec', function():String { return 'debug message'; });
            it.expects(testPrinter.lastMessage).toBeEmpty();

            Log.level = lastLevel;
        }

        private static function log_lazily():void
        {
            var lastLevel:LogLevel = Log.level;
            var initialValue:Number = 0;
            var captive:Number = initialValue;

            Log.level = LogLevel.INFO;
            Log.debug('LogSpec', function():String { captive++; return 'debug message executed'; });
            it.expects(captive).toEqual(initialValue);

            Log.level = LogLevel.DEBUG;
            Log.debug('LogSpec', function():String { captive++; return 'debug message executed'; });
            it.expects(captive).toEqual(initialValue + 1);

            Log.level = lastLevel;
        }
    }


    class TestPrinter implements Printer
    {
        private var printedMessage:String = '';

        public function print(message:String):void
        {
            printedMessage = message;
        }

        public function get lastMessage():String
        {
            var m:String = printedMessage;
            printedMessage = '';

            return m;
        }
    }
}
