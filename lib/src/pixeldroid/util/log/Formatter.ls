package pixeldroid.util.log
{
    /**
    Provides a message formatting function for use by `Log`.

    Message format style is up to the implementing class.

    @see pixeldroid.util.log.Log#formatter
    @see pixeldroid.util.log.LogLevel
    */
    interface Formatter
    {
        /**
        Formats a message prior to printing.

        @param time The number of milliseconds since app start
        @param level A `LogLevel` constant representing verbosity of the message
        @param label A name for the owner of the message
        @param message The message to be logged

        @return An implementation-dependent formatted string

        @see pixeldroid.util.log.LogLevel
        */
        function format(time:Number, level:LogLevel, label:String, message:String):String;
    }
}
