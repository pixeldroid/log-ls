package pixeldroid.util.log
{
    /**
        Enumerates the verbosity levels of the logging system, from `NONE` (least verbose) to `DEBUG` (most verbose).

        The order of increasing verbosity is: `NONE` < `FATAL` < `ERROR` < `WARN` < `INFO` < `DEBUG`.

        * `NONE` indicates no logging should occur.
        * `FATAL` allows only messages related to application crashes.
        * `ERROR` adds messages related to unexpected results that will break expected behavior.
        * `WARN` adds messages related to unexpected results that will not break expected behavior.
        * `INFO` adds messages that track happy path execution.
        * `DEBUG` adds messages that track program state.

        Use Log.levelToString() to retrieve a text representation of the level.

        @see pixeldroid.util.Log#levelToString
        @see pixeldroid.util.Log#levelFromString
    */
    enum LogLevel
    {
        NONE = 0,
        FATAL,
        ERROR,
        WARN,
        INFO,
        DEBUG
    }
}
