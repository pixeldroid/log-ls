package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.Log;
    import pixeldroid.util.log.LogLevel;
    import pixeldroid.util.log.FilePrinter;
    import pixeldroid.util.log.Printer;

    import LogStatePreserver;


    public static final class FilePrinterSpec
    {
        private static const it:Thing = Spec.describe('FilePrinter');
        private static const wrap:Function = LogStatePreserver.wrap;

        public static function describe():void
        {
            it.should('save to file when printed to', wrap(save_to_file) as Function);
            it.should('support appending to the latest line', append_to_line);
            it.should('support replacing the latest line', replace_line);
            it.should('enforce message limits by rolling off oldest messages', roll_off);
            it.should('log a message when changing the logfile', change_logfile);
        }


        private static function save_to_file():void
        {
            var testPrinter:TestFilePrinter = new TestFilePrinter();

            Log.level = LogLevel.INFO;
            Log.printer = testPrinter as Printer;

            it.expects(testPrinter.wasSaveCalled).toBeFalsey();
            Log.info('FilePrinterSpec', function():String { return 'info message'; });
            it.expects(testPrinter.wasSaveCalled).toBeTruthy();
        }

        private static function append_to_line():void
        {
            var testPrinter:TestFilePrinter = new TestFilePrinter();
            var a:String = 'message beginning';
            var b:String = 'and ending';

            testPrinter.print(a);
            it.expects(testPrinter.messages.length).toEqual(1);

            testPrinter.append(b);
            it.expects(testPrinter.messages.length).toEqual(1);
            it.expects(testPrinter.messages[0]).toEqual(a +' ' +b);
        }

        private static function replace_line():void
        {
            var testPrinter:TestFilePrinter = new TestFilePrinter();
            var a:String = 'message';
            var b:String = 'replacement';

            testPrinter.print(a);
            it.expects(testPrinter.messages.length).toEqual(1);
            it.expects(testPrinter.messages[0]).toEqual(a);

            testPrinter.replace(b);
            it.expects(testPrinter.messages.length).toEqual(1);
            it.expects(testPrinter.messages[0]).toEqual(b);
        }

        private static function roll_off():void
        {
            var testPrinter:TestFilePrinter = new TestFilePrinter();
            var limit:Number = 3;

            for (var i:Number = 0; i < limit*2; i++) testPrinter.print(i.toString());
            it.expects(testPrinter.messages.length).toEqual(limit*2);

            testPrinter.messageLimit = limit;
            it.expects(testPrinter.messages.length).toEqual(limit);
            it.expects(testPrinter.messages[0]).toEqual(limit.toString());
        }

        private static function change_logfile():void
        {
            var testPrinter:TestFilePrinter = new TestFilePrinter();
            var newLogfile:String = 'new/path/to/logfile.log';

            it.expects(testPrinter.wasSaveCalled).toBeFalsey();
            it.expects(testPrinter.logfile).not.toEqual(newLogfile);

            testPrinter.setLogfile(newLogfile);

            it.expects(testPrinter.logfile).toEqual(newLogfile);
            it.expects(testPrinter.wasSaveCalled).toBeTruthy();
        }
    }

    class TestFilePrinter extends FilePrinter
    {
        private var isSaved:Boolean = false;
        public function get wasSaveCalled():Boolean { return isSaved; }
        public function get messages():Vector.<String> { return data.slice(); }
        override protected function save():Boolean { return (isSaved = true); }
    }
}
