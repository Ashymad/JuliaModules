module Extenders

module GastonExtender

    import Gaston
    export gplot

    function Gaston.gnuplot_init(args::String)

        if Gaston.gnuplot_state.running
            Gaston.gnuplot_exit()
        end

        pr = (0,0,0,0) # stdin, stdout, stderr, pid
        try
            pr = Gaston.popen3(`gnuplot $args`)
        catch
            error("There was a problem starting up gnuplot.")
        end
        # It's possible that `popen3` runs successfully, but gnuplot exits
        # immediately. Double-check that gnuplot is running at this point.
        if Base.process_running(pr[4])
            Gaston.gnuplot_state.running = true
            Gaston.gnuplot_state.fid = pr
            # Start tasks to read and write gnuplot's pipes
            yield()  # get async tasks started (code blocks without this line)
            notify(Gaston.StartPipes)
        else
            error("There was a problem starting up gnuplot.")
        end
    end

    function gplot(args...)
        Gaston.gnuplot_init("--persist")
        Gaston.plot(args...)
        Gaston.gnuplot_exit()
    end
end

end