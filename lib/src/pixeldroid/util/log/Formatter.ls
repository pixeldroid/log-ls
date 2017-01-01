package pixeldroid.util.log
{
    /**
        Declares a message formatting function for use by Log.

        @see pixeldroid.util.Log#formatter
        @see pixeldroid.util.log.LogLevel
    */
    interface Formatter
    {
        /**
            @param time The number of milliseconds since app start
            @param level A `LogLevel` constant representing verbosity of the message
            @param label A name for the owner of the message
            @param message The message to be logged
        */
        function format(time:Number, level:LogLevel, label:String, message:String):String;
    }
}
