package pixeldroid.util.log.printers
{

    import pixeldroid.util.log.Printer;

    /**
        Provides a one-to-many facade for logging a single message to multiple printers.

        @see pixeldroid.util.log.Printer
    */
    class MultiPrinter implements Printer
    {
        /**
        List of message receivers compliant with the `Printer` interface.

        All printers in the list are printed to each time the `print()` method of this class is called.

        @see pixeldroid.util.log.Printer
        */
        protected var printers:Dictionary.<String,Printer>;

        /** Value used to generate a default index for the next printer added. */
        protected var index:Number = 1;


        public function MultiPrinter()
        {
            printers = {};
        }


        /** @copy pixeldroid.util.log.Printer */
        public function print(message:String):void
        {
            for each (var printer:Printer in printers)
            {
                printer.print(message);
            }
        }

        /**
        Add a printer to the list of message recievers.

        Each printer in the list will record any message send to the `print()` method of this class.

        @param printer A message receiver compliant with the `Printer` interface
        @param key An optional key to store the printer under. When not provided, a default key is created.
        @return The key for the added printer. Can be used for removal.

        @see pixeldroid.util.log.Printer
        */
        public function add(printer:Printer, key:String = null):String
        {
            if (!key) key = 'printer' +(index++);

            printers[key] = printer;

            return key;
        }

        /**
        Remove all printers from the list of message receivers.
        */
        public function clear():void
        {
            printers.clear();
        }

        /**
        Count of printers currently in the list of message receivers.

        @return The number of printers currently in the list of message receivers
        */
        public function get numPrinters():Number { return printers.length; }

        /**
        Keys for all printers currently in the list of message receivers.

        @return A `Vector` of `String` keys. Keys can be used to remove a printer from the list of message receivers.
        */
        public function get printerKeys():Vector.<String>
        {
            var keys:Vector.<String> = [];
            for (var k:String in printers) keys.push(k);

            return keys;
        }

        /**
        Remove a printer matching the provided key from the list of message recievers.

        @param key A key to identify the printer to remove
        @return The `Printer` instance removed

        @see pixeldroid.util.log.Printer
        */
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
