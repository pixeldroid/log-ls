package pixeldroid.util.log
{
    /**
        Enumerates the verbosity levels of the logging system, from `NONE` (least verbose) to `DEBUG` (most verbose).

        The order of increasing verbosity is: `NONE` < `FATAL` < `ERROR` < `WARN` < `INFO` < `DEBUG`.
        - `NONE` indicates no logging should occur.
        - `FATAL` allows only messages related to application crashes.
        - `ERROR` adds messages related to unexpected results that _will_ break expected behavior.
        - `WARN` adds messages related to unexpected results that will _not_ break expected behavior.
        - `INFO` adds messages that track happy path execution.
        - `DEBUG` adds messages that track program state.

        Use `Log.levelToString()` to retrieve a text representation of the level.

        @see pixeldroid.util.log.Log#levelToString
        @see pixeldroid.util.log.Log#levelFromString
    */
    enum LogLevel
    {
        /** indicates no logging should occur */
        NONE = 0,

        /** for messages related to application crashes */
        FATAL,

        /** for messages related to unexpected results that _will_ break expected behavior */
        ERROR,

        /** for messages related to unexpected results that will _not_ break expected behavior */
        WARN,

        /** for messages that track happy path execution */
        INFO,

        /** for messages that track program state */
        DEBUG
    }
}
