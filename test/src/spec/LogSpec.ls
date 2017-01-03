package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.Log;
    import pixeldroid.util.log.LogLevel;
    import pixeldroid.util.log.Printer;

    import LogStatePreserver;
    import TestPrinter;


    public static final class LogSpec
    {
        private static const it:Thing = Spec.describe('Log');
        private static const wrap:Function = LogStatePreserver.wrap;
        private static var initialLevel:LogLevel;

        public static function describe():void
        {
            before();

            it.should('be versioned', be_versioned);
            it.should('default to INFO level logging', default_to_info);
            it.should('provide a set of increasing verbosity levels', provide_levels);
            it.should('not log messages more verbose than the current log level', wrap(ignore_higher_levels) as Function);
            it.should('not compute messages that are not logged', wrap(log_lazily) as Function);
        }


        private static function before():void
        {
            initialLevel = Log.level;
        }

        private static function be_versioned():void
        {
            it.expects(Log.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function default_to_info():void
        {
            it.expects(initialLevel).toEqual(LogLevel.INFO);
            it.expects(initialLevel).toEqual(Log.defaultLevel);
            it.expects(Log.defaultLevel).not.toBeNull();
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
            var testPrinter:TestPrinter = new TestPrinter();
            Log.printer = testPrinter;

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
        }

        private static function log_lazily():void
        {
            var initialValue:Number = 0;
            var captive:Number = initialValue;
            var testPrinter:TestPrinter = new TestPrinter();

            Log.printer = testPrinter;

            Log.level = LogLevel.INFO;
            Log.debug('LogSpec', function():String { captive++; return 'debug message executed'; });
            it.expects(captive).toEqual(initialValue);

            Log.level = LogLevel.DEBUG;
            Log.debug('LogSpec', function():String { captive++; return 'debug message executed'; });
            it.expects(captive).toEqual(initialValue + 1);
        }
    }
}
