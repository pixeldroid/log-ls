package
{
    import pixeldroid.util.log.Printer;


    public class TestPrinter implements Printer
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
