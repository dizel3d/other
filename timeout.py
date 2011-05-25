"""
Timeout extending for functions like IO
functions (e.g. read, raw_input, input).
"""
import signal

def addtimeout0(func):
    """
    This decorator adds property of timer for functions like IO
    functions (e.g. read, raw_input, input) by generation of SIGALRM.
    For example,
      @addtimeout0
      def input1():
          return sys.stdin.readline()
      # after 3 seconds waiting this system call will be
      # interruped by SIGALRM with exception raising
      print input1(3)()
    or
      # alternative way
      print addtimeout0(sys.stdin.readline)(3)()
    """
    def t(timeout):
        def f(*args, **kwargs):
            def handler(*args):
                pass
            signal.signal(signal.SIGALRM, handler)
            signal.alarm(timeout)
            ret = func(*args, **kwargs)
            signal.alarm(0)
            return ret
        return f
    return t

def addtimeout(func):
    """
    This decorator works like addtimeout0, but throws exeptions:
     - EnvironmentError if "[Errno 4] Interrupted system call";
     - EOFError.
    """
    def func2(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except EnvironmentError as e:
            if e.errno != 4:
                raise
        except EOFError as e:
            pass
    return addtimeout0(func2)

"Examples."
if __name__ == "__main__":
    import sys

    @addtimeout0
    def input1():
        return sys.stdin.readline()

    try:
        print input1(1)()
    except EnvironmentError:
        print "EnvironmentError"

    try:
        print addtimeout0(input)(1)()
    except EOFError:
        print "EOFError"

    print addtimeout(input)(1)()
    print addtimeout(sys.stdin.read)(1)(1)
