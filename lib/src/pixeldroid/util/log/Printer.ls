package pixeldroid.util.log
{
    /**
    Provides a receiver function for use by `Log`.

    Once received, the log message handling is up to the implementing class.

    @see pixeldroid.util.Log#printer
    */
    interface Printer
    {
        /**
        Record a log message.

        Message formatting occurs prior to this method being called.

        @param message The formatted message to be handled by a log receiver
        */
        function print(message:String):void;
    }
}
