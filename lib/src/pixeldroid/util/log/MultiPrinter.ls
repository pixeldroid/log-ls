package pixeldroid.util.log
{

    import pixeldroid.util.log.Printer;

    /**
        Provides a simple console logger for use by Log.

        Log messages are sent to stdout via system.Console:

        @see system.Console#print
    */
    class MultiPrinter implements Printer
    {
        protected var printers:Dictionary.<String,Printer>;
        protected var index:Number = 1;


        public function MultiPrinter()
        {
            printers = {};
        }


        public function print(message:String):void
        {
            for each (var printer:Printer in printers)
            {
                printer.print(message);
            }
        }

        public function add(printer:Printer, key:String = null):String
        {
            if (!key) key = 'printer' +(index++);

            printers[key] = printer;

            return key;
        }

        public function clear():void
        {
            printers.clear();
        }

        public function get numPrinters():Number { return printers.length; }

        public function get printerKeys():Vector.<String>
        {
            var keys:Vector.<String> = [];
            for (var k:String in printers) keys.push(k);

            return keys;
        }

        public function remove(key:String):Printer
        {
            var printer:Printer;

            if (printers[key])
            {
                printer = printers[key];
                printers.deleteKey(key);
            }

            return printer;
        }
    }
}
