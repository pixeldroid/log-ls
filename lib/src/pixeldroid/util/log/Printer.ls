package pixeldroid.util.log
{
    /**
        Declares a receiver function for use by Log.

        @see pixeldroid.util.Log#printer
    */
    interface Printer
    {
        /**
            @param message The message to be printed to a log receiver
        */
        function print(message:String):void;
    }
}
