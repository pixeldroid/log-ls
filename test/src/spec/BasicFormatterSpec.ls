package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.Log;
    import pixeldroid.util.log.LogLevel;
    import pixeldroid.util.log.Printer;

    import LogStatePreserver;
    import TestPrinter;


    public static final class BasicFormatterSpec
    {
        private static const it:Thing = Spec.describe('BasicFormatter');
        private static const testPrinter:TestPrinter = new TestPrinter();
        private static const wrap:Function = LogStatePreserver.wrap;

        public static function describe():void
        {
            it.should('provide a default format for time, level, label, and message', wrap(provide_default_format) as Function);
        }


        private static function provide_default_format():void
        {
            Log.printer = testPrinter;

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
        }
    }
}
