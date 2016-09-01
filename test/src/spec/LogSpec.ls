package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.Log;
    import pixeldroid.util.LogLevel;
    import pixeldroid.util.Printer;

    public static class LogSpec
    {
        public static function describe():void
        {
            var testPrinter:TestPrinter = new TestPrinter();
            var defaultLevel:LogLevel = Log.level;
            Log.printer = testPrinter;

            var it:Thing = Spec.describe('Log');

            it.should('be versioned', function() {
                it.expects(Log.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
            });

            it.should('default to ERROR level logging', function() {
                it.expects(LogLevel.areEquivalent(defaultLevel, LogLevel.ERROR)).toBeTruthy();
            });

            it.should('provide a default format for time, level, label, and message', function() {
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
            });

            it.should('provide a set of increasing verbosity levels', function() {
                it.expects(LogLevel.NONE.value ).toBeLessThan(LogLevel.FATAL.value);
                it.expects(LogLevel.FATAL.value).toBeLessThan(LogLevel.ERROR.value);
                it.expects(LogLevel.ERROR.value).toBeLessThan(LogLevel.WARN.value);
                it.expects(LogLevel.WARN.value ).toBeLessThan(LogLevel.INFO.value);
                it.expects(LogLevel.INFO.value ).toBeLessThan(LogLevel.DEBUG.value);
            });

            it.should('not log messages above the current log level', function() {
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
            });

            it.should('not compute messages that are not logged', function() {
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
            });
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
