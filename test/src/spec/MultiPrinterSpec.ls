package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.log.Log;
    import pixeldroid.util.log.LogLevel;
    import pixeldroid.util.log.printers.MultiPrinter;
    import pixeldroid.util.log.Printer;

    import TestPrinter;


    public static final class MultiPrinterSpec
    {
        private static var it:Thing;
        private static const testPrinter1:TestPrinter = new TestPrinter();
        private static const testPrinter2:TestPrinter = new TestPrinter();

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('MultiPrinter');

            it.should('proxy multiple printers', proxy_multiple);
            it.should('add and remove printers by id', add_and_remove);
            it.should('auto-create ids by default', create_ids);
            it.should('remove all added printers', clear_printers);
        }


        private static function proxy_multiple():void
        {
            var multiPrinter:MultiPrinter = new MultiPrinter();
            multiPrinter.add(testPrinter1, 'p1');
            multiPrinter.add(testPrinter2, 'p2');

            Log.printer = multiPrinter as Printer;
            Log.level = LogLevel.INFO;

            var lbl:String = 'MultiPrinterSpec';
            var msg:String = 'info message';

            Log.info(lbl, function():String { return msg; });

            var m1:String = testPrinter1.lastMessage;
            var m2:String = testPrinter2.lastMessage;

            it.expects(m1).toPatternMatch('%s(' +lbl +').*(' +msg +')$', 2);
            it.expects(m2).toEqual(m1);
        }

        private static function add_and_remove():void
        {
            var multiPrinter:MultiPrinter = new MultiPrinter();

            it.expects(multiPrinter.numPrinters).toEqual(0);

            multiPrinter.add(testPrinter1, 'p1');
            multiPrinter.add(testPrinter2, 'p2');

            it.expects(multiPrinter.numPrinters).toEqual(2);

            var keys:Vector.<String> = multiPrinter.printerKeys;
            keys.sort();
            it.expects(keys.join()).toEqual(['p1', 'p2'].join());

            var tp:TestPrinter = multiPrinter.remove('p2') as TestPrinter;

            it.expects(multiPrinter.numPrinters).toEqual(1);
            it.expects(tp).toEqual(testPrinter2);
        }

        private static function create_ids():void
        {
            var multiPrinter:MultiPrinter = new MultiPrinter();

            multiPrinter.add(testPrinter1);
            multiPrinter.add(testPrinter2);

            var keys:Vector.<String> = multiPrinter.printerKeys;
            keys.sort();
            it.expects(keys.join()).toEqual(['printer1', 'printer2'].join());
        }

        private static function clear_printers():void
        {
            var multiPrinter:MultiPrinter = new MultiPrinter();

            it.expects(multiPrinter.numPrinters).toEqual(0);

            multiPrinter.add(testPrinter1, 'p1');
            multiPrinter.add(testPrinter2, 'p2');

            it.expects(multiPrinter.numPrinters).toEqual(2);

            multiPrinter.clear();

            it.expects(multiPrinter.numPrinters).toEqual(0);
        }
    }
}
