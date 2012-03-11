include(`report-header.tex')

% homeless stuff

% Note : The compiler can not always detect paralell output to a channel.
% depending on ehere the calculation of the loop variable is done

dnl \\
dnl \\
dnl Channels in Occam are point-to-point, uni-directional and unbuffered.  All
dnl communication between processes is via channels.  Communication takes place
dnl when both the sending and the receiving processes have reached the communicating
dnl statement.

\abstract
This is a first hands-on experience with CSP using the Occam programming
language.  A (pawn) chess game and a simple library for experimenting with
digital logic have been implemented.  The design of these programs, findings and
experiences with Occam are discussed.

\tableofcontents

\newpage
\setcounter{page}{1}  % This is thereal first page

\fancyhead[RO]{\textbf{\thepage}}      %Displays the page number in bold in the header,
\fancyhead[LO]{\textbf{\leftmark}}      %Displays the page number in bold in the header,


\section{Conclusion}

I have successfully implemented a simple pawn chess simulation and a basic
simulation of a ripple carry adder and a multiplexer using the KRoC \cite{kroc}
implementation of the Occam language.  By learning one of the most simple
languages that uses CSP I have become comfortable with basic CSP concepts.
\\
\\
% reading a file
It was surprising that I had to give up trying to read a file from the disk and
suspect that there is a difference in the nature of the standard input channel
(first argument to the ``\texttt{main}'' \lstinline{PROC}) and other channels of
type \texttt{CHAN OF BYTE kyb?}.  I would investigate this when working with
Occam in the future.
% How many running processes are there ?
\\
\\
A feature I missed but looked for for quite some time without much success was a
way to find out how many processes a program had been running.  


% Alt and PRI ALT

\section{CSP and Occam}

% Why Occam?
%
% Transputer
%
% Transterpreter
I have chosen to implement the two assignments for this course in Occam because
it seemed to be the most interesting implementation of CSP. This is for several reasons:
Occam is one of, if not \textit{the} first programming language that implements Tony
Hoare's CSP (Communicating Sequential Processes) \cite{csp}.  

I also find Occam to be the most pure of the CSP implementations that have been
presented during the lectures.  Occam is simple and makes it easier to think
about concurrency.  There are not many language features that make it easy to design a program in a
way that breaks with the CSP model.  Not to say that this is not possible, but
the inherent ``Ockhams razor'' nature of Occam programs make it difficult.

In java and C++, JCSP and C++CSP are library extensions to the language and so one might
easier be lulled into thinking that non-CSP constructs like sharing data between processes is
allowed.
\\
\\
Development on Occam started at Inmos Limited, Bristol, England round 1983. A
VLSI chip called the Transputer was developed from the Occam model.  The
Transputer was designed in such a way that it was possible to put several
Transputers together to form a network.  In this way systems built from transputers
could be made to scale effectively \cite{occam:intro}.  I find this model of
scalability very interesting.
\\
\\
I am not sure what has happened to the Transputer but in the current day the
Transterpreter seems to have taken over where the transputer left off.  The
Transterpreter is an interpreter for running Occam programs.  It has been
ported to many platforms and is very small: only about 2000 lines of c code.
More info can be found at the Transterpreter web page \cite{transterpreter},
a page I have also found to be an excellent resource for getting started with
Occam.
\\
\\
All this is very exciting.  To continue the performance growth rate stated by
Moores Law it becomes increasingly important to look more closely into
concurrently running computations.  This can be seen in the recent popularity of
multicore CPUs. CSP in being formally proven correct is an excellent tool for
making concurrent programs.  

% This, we know

\subsection{Getting started}

I have used the KRoC v. 1.4.0 implementation of the Occam language.  

This compiler implements Occam 2 plus some extensions, the language is loosely
referred to as Occam-M or Occam-Pi. It seems that this has most of the features
of Occam 2.5 \cite{occ:definition} plus extensions. A nice
but somewhat brief overview of the Occam language for programmers familiar with
java, c, etc. is given in \cite{occam:tutor}.
\\
\\
As declared in \cite{occam:intro} the design of an Occam program should start
with a drawing a diagram of concurrent processes as boxes and channels as the
lines of communication that connecting them.  Afterwards the processes
that implement the communication should be written and at last these should be
wired together.  I have followed this method of implementation. 
\\
\\
Every line of code may be considered to be a process in Occam.  All
communication between processes happens through channels which are point to
point, directed and unbuffered.  A sending process will wait for the receiving
process and vice versa.

The basic building bloc of Occam processes is the \lstinline{PROC} which can be
used as Pascal procedures and as processes or rather ``boxes'' of processes with
channels going in and coming out.

Debugging Occam code is difficult.  There is no debugger that I am aware of, and
it is not possible to use print statements once a program becomes a little
complex.  This is because all output must go to the screen channel, and it is
impractical and sometimes impossible to wire this channel into every
\lstinline{PROC}.  The lack of on-place debugging facilities can be frustrating
at times.
\\
\\
I found that a convenient way to debug processes in the program was to declare
a main function for each \lstinline{PROC} that I would like to debug and
gradually approach the assembling of \lstinline{PROC}s and channels by
uncommenting the bottommost \lstinline{PROC} (which acts like C's \texttt{main}
function) and writing a new ``\texttt{main}'' to test another \lstinline{PROC}
or maybe uncummenting a previous ``\texttt{main}'' function. This is a somewhat
arcane method of debugging, but lacking a better way this worked out fine.
\\
\\
% measuring concurrency with gdb : how many processes run?
I have tried to find out some way to display information about the threads in an
Occam program.  The KRoC manual pages do not seem to mention a way to do this.
Using the \texttt{gdb} debugger to find out the amount of threads that are
active is possible, but only when threads are suspended. 

\section{Pawn chess}

In the following I will describe the implementation of the pawn chess program
It is essentially a concurrent implementation of the minimax algorithm,
including the alpha beta cutoff optimization. Both are described in
\cite{aibook}.  

% rules
I have chosen to use the simplest rules for pawn chess.  In the initial position
a pawn may move two fields forward, otherwise a pawn may move only one field
forward.  A diagonal move is allowed if one of the opponents pawns is in a
diagonally adjacent field in the movement direction. 
\\
\\
% What the prog does, minimax 
When the program is run the computer will play a game of pawn chess against
itself displaying the board after each move until the game terminates.  
Each of the players moves is decided by a call to the minimax algorithm.
In many implementations this is done by recursively calling the minimax function, which
alternates between the minimizing and maximizing player through the recursive
calls.  Eventually the cutoff depth is reached, at which point an evaluation
function is called to give an estimate of the utility of the current board
position.  This estimate is returned to the calling function.
\\
\\
The evaluation function is important for good gameplay and its value should
reflect the actual utility value of a board state for the current player. I have chosen not to implement a very
good evaluation function and this can be seen on the gameplay.  In a better
implementation a significant amount of work should be put into designing a good
evaluation function and also the function would do a lot of work when gathering
information about the game state so it would typically be computationally
expensive. 

For this reason the evaluation function is also an excellent
candidate for distribution among several threads/processors.

\subsection{Program design}

It took me a while to come up with a design that would exhibit open ended
concurrency.  It is not possible to dynamically allocate memory in Occam
programs and as far as I know recursive \lstinline{PROC}s are not well
supported.  Eventually I did arrive at a design that I think is good.  Figure
\ref{fig:pawn} is a diagram that describes the design. A good thing about
this design is that each branch is easy to extend to let the minimax algorithm
search deeper.
This can be done by changing the variable \texttt{depth} at the top of the
\texttt{pawn-chess.occ} file.

\begin{figure} 
 \centering 
 \includegraphics[width=0.9\textwidth]{pawn_chess.eps} 
 \caption{This is the network of \lstinline{PROC}s that is used to calculate
 each next move in the pawn chess game.  When the game starts a board with all
 pieces in the initial position is created in \texttt{main} and sent to
 each index in the \texttt{directory}.  Each node in the branches concurrently pass on the
 next permutation of the board that was initially received.  When a board
 reaches a leaf node the utility of the board is calculated. This minimax value is sent
 back up through the branch. When all branches have finished the board state
 corresponding best minimax value is chosen as the players move. } 
 \label{fig:pawn} 
\end{figure}


\begin{figure} 
 \centering 
 \includegraphics[width=0.5\textwidth]{node.eps} 
 \caption{The wiring of a single node.  Channels are labelled with the direction
 and message type that they transport. } 
 \label{fig:node} 
\end{figure}

The wiring of the internal nodes is shown in figure \ref{fig:node}.  When an
internal node receives a board at its input channel it computes all permutations
of this board and sends them down its \texttt{board.out} channel.  Hereafter an
integer value representing the evaluation of the board state is received from
the process to which the board was sent.  This continues until there are no
more boards to send further down the branch, or until a value is received that
causes an alpha or a beta cutoff, at which point this value is sent back up the
branch.


% termination, POISON
\subsection{\texttt{POISON}ing \lstinline{PROC}s}

To avoid deadlock and gracefully shut down the program when the simulation
finishes, processes must be shut down in the right order.  To achieve this I
have added a \texttt{POISON} tag to the \texttt{PBOARD} \lstinline{PROTOCOL}.
This protocol is used in all channels going towards leaf nodes.
Each continually running processes contains a loop variable that is
\texttt{TRUE} while the process is running.  When the process receives a
\texttt{POISON} message it passes this message downstream and sets its loop
variable to \texttt{FALSE} thereby terminating itself.
When a winner has been found the \texttt{POISON} tag is sent down each branch
effectively causing all processes to terminate.

\subsection{Minor issues}

% Brief description of problems
When a node receives an incoming board the node makes all the possible moves
that the player who's turn it is could make and stores them in an array.  One
by one these boards are sent down the \texttt{board.out} output channel as shown
in figure \ref{fig:node}.  A problem with this method is that many board states
are calculated but not used because an alpha or a beta cutoff takes place.
It would be better and likely more efficient to let the next be calculated by a
separate \lstinline{PROC} only when it is needed.

% There are some other optimizations that can be made,...

% bubblesort, other minor stuff
% dnl There exist other minor problems with the implementation is th
% Amount of concurrency


% Harness of procs
% 
% Each step in the recursion throught the minimax tree is handled by a single
% \lstinline{PROC}.
% 
% 
% Here goes more text with details on how i wrote the pawn chess implementation..
% Maybe something about correctness.   Is is correct?
% 
% I should implement one more detail to the eval function: a pawn charges ahead if
% there is free room to do so.
% 

% Not necessary to calculate all next boards
% Most probable boards considered first to make a better cutoff percentage

% The eval function is very important.
% Central to functionality
% The implementation does not play well due to not much effort put into this

% Randomization of moves

\subsection{Performance}

I was lucky to have access to a dual Intel Xeon machine and was curious about
how well the pawn chess game would perform on a dual processor machine when
compared to the performance on a single processor machine.  This measure could
hint at how large a performance boost could be gained from a multiprocessor
machine.  To get a useful comparison of this, it  would have been nice to also
have tested the pawn chess program on a single processor 2.8 Ghz Intel Xeon
machine. This would be necessary to be able to deduce anything about the
performance gain due to concurrency, but I have not had the opportunity.


% dnl 1.      & FreeBSD 6.2               &     946.718   &   900Mhz AMD Duron      \\ \hline


\begin{figure} 
	\centering 
	\begin{tabular}{|c|l|r|c|}\hline
		Machine & Operating System          &    CPU-time   &       CPU               \\ \hline \hline
		1.      & Fedora Core 4 2.6.16-1    &    1662.175   & AMD Athlon MP 2000+     \\ \hline
		2.      & Fedora Core 4 2.6.15-2    &    2791.502   &  2x 2.8Ghz Intel Xeon   \\ \hline
	\end{tabular}
	\caption{Machines on which the pawn chess game was tested}
	\label{fig:machines} 
\end{figure}

On figure \ref{fig:machines} it can be seen that each of the two 2.8 Ghz Intel Xeon processors 
have a clock frequency that is roughly $1.7$ times that of the AMD Athlon MP
2000+ chip. \protect{\footnote{The cpu time was measured with the \texttt{cputimerutil}
program which comes with the \texttt{KRoC-1.4.0} distribution. }}. 
It is good that the results are consistent on the different machines!
Note that player 1 wins almost all the games except the last ones where the
search depth is set to 9.

\begin{figure} % TODO : Gather timings
	\centering 
	\begin{tabular}{|c|r|r|r|r|r|}\hline
		Machine & d. 5/win & d. 6/win & d. 7/win & d. 8/win  & d. 9/win    \\ \hline \hline
		1.      & 2.2s/1   & 7.2s/1   & 36.1s/1  & 1m49.7s/1 & 10m37.2s/0  \\ \hline
		2.      & 1.7s/1   & 5.8s/1   & 26.6s/1  & 1m27.1s/1 & 8m17.9s/0   \\ \hline
	\end{tabular}
	\caption{Time taken to run a simulation of the pawn chess game.  For each measurement the title
	row shows: depth of the minimax search / winner of the game. Notice that player 0 wins the last
	games where the search depth is 9.}
	\label{fig:timings} 
\end{figure}


% needed?
% \newpage

\section{Digital circuit simulation}

I found the implementation of the digital logic library more straightforward
than the pawn chess game.  The basic logical components were fairly simple to
implement. Drawing a diagram and wiring up the \lstinline{PROC}s is also very
much on par with the typical approach to the implementation of an Occam program.
This makes Occam seem like a very well suited pick for the implementation of a
digital logic library.
\\
\\
The library presented here is very simple.  Timing has not been implemented, and
I have chosen to implement the ripple carry adder, which is not so efficient,
but very simple.

The most difficult part of the implementation was the testing of the adder and
multiplexer.  I had quite a few difficulties with something as simple as getting
Occam to read input from a file.  I finally gave up and instead read all test
input from the standard input channel.

\subsection{A full adder}

I have implemented a full adder as the one shown in figure \ref{fig:fulladder}.
Full adders can be combined in several ways to form an adder capable of
adding more bits together.  This can be done in many different ways, the most
simple being the ripple carry adder.  This is the adder that has been made for
the simulation library. 

In the file \texttt{circuitlib.occ} the chaining of full adders is done in a
separate \lstinline{PROC}.  By modifying the value of \texttt{BITS} at the top
of the file it is possible to change the amount of wires that go into the adder. 


\begin{figure} 
 \centering 
 \includegraphics[width=0.7\textwidth]{fulladder.eps} 
 \caption{This is the full adder implemented.  Multiple full adders may chained together by
 connecting the carry in and carry out channels to form a ripple carry adder.
 This is not good for the concurrency however because each full adder must wait
 for the carry out value of the previous adder.} 
 \label{fig:fulladder} 
\end{figure}

\subsection{A $3-1$ multiplexer}

A multiplexer selects which one of several incoming wires should be displayed on
the output wire.  Typically $\log n$ wires are used to chose which one of $n$
wires is output.  The $3-1$ multiplexer is different and a little inefficient in
the sense that there is one unused combination of the two selector inputs.  I
have chosen not to handle this selector input. 

The equation that expresses the output of the $3-1$ multiplexer I have implemented is:

\begin{eqnarray*}
   F & = & (i_{0}\cdot\bar{s_{0}}\cdot\bar{s_{1}})+(i_{1}\cdot s_{0}\cdot\bar{s_{1}})+(i_{2}\cdot\bar{s_{0}}\cdot s_{1})
\end{eqnarray*}


\begin{figure} 
 \centering 
 \includegraphics[width=0.8\textwidth]{mux.eps} 
 \caption{A diagram of the 3-1 multiplexer that has been implemented. Channels
 $s_{0}$ and $s_{1}$ select between the input channels $i_{0-2} $.  In the case
 where $s_{0}=1$ and $s_{1}=1$ the value on $z$ is considered to be undefined. } 
 \label{fig:mux} 
\end{figure}

\subsection{Test of correctness}

To assert that the Occam adder and multiplexer behave correctly I have made C
implementations of them both in \texttt{test-reference.c}.  The \texttt{test}
makefile target will compile and run \texttt{create-input.c} to create all
possible permutations of binary input to the adder and multiplexer respectively.


The test shows that both of the adder and multiplexer implementations produce
the same output, which is nice.

\newpage

\section{Getting, building and running the code}

All code was written and tested with the Kent Retargettable Occam-pi Compiler
(KRoC) \cite{kroc} version 1.4.0 on an i686 GNU/Linux machine.  
\\
\\
The code is available for download at the following
locations:

\begin{itemize}
		\item \url{http://bladre.dk/em}
		\item \url{http://itu.dk/people/anderslt/em}.
\end{itemize}

You must download and unzip the file
\texttt{Ekstrem-Multiprogrammering-2007-Anders-L-Thogersen.tar.gz}.
\\
\\
To build the code you will need a GNU make and binutils packages and a C
compiler as well as a compatible version of the KRoC compiler.
\\
\\
If your Occam environment is set up rightly, you should be able to run
\texttt{make test} inside of the \texttt{kroc} directory. This will build all
programs, run the digitals circuit tests and start a pawn chess simulation.

Before running the \texttt{test} target you might have to edit the makefile to
let the \texttt{KROKBASE} variable point to the directory that contains the
\texttt{vtinclude} and \texttt{vtlib} directories from the KRoC distribution.
\\
\\
You might also want to look at the beginning of the \texttt{pawn-chess.occ} file to
change parameters like the minimax search depth and others.

\newpage

\bibliography{bibliography}

\newpage

% no underlines in the source listings
%dnl \fancyhf{}
%dnl \renewcommand{\headrulewidth}{0pt}      %Underlines the header. (Set to 0pt if not required).
%dnl \renewcommand{\footrulewidth}{0pt}      %Underlines the footer. (Set to 0pt if not required).

\begin{appendix}

\section{APPENDIX}

%dnl All program code has been ``syntax highlighted'' with the latex listings
%dnl package. Occam hilighting 
%dnl using the \cite{occam:listings} customization.


\subsection{makefile}

The makefile contains targets to build all files needed to run both the pawn
chess ``game'' and to build the Occam circuit library.  Note that the test of
correctness of the latter is done by the \tt{test} make target.

\lstset{language=make, keywordstyle=\bf}

\begin{lstlisting}
include(`../kroc/makefile') dnl
\end{lstlisting}
\newpage

\lstset{language=occam, keywordstyle=\bf}

\subsection{pawn-chess.occ}

This is an simple implementation of a pawn chess game in Occam.  You can change
the values of the \texttt{depth}, \texttt{DEBUG}, and \texttt{randomly.pick}
variables to alter the programs behaviour.

\begin{lstlisting}
include(`../kroc/pawn-chess.occ') dnl
\end{lstlisting}
\newpage

\subsection{Circuit simulation library and test tools}

\subsubsection{circuitlib.occ}
This is an implementation of a basic library for simulation of digital logic
written in Occam.
\begin{lstlisting}
include(`../kroc/circuitlib.occ') dnl
\end{lstlisting}
\newpage

\subsubsection{test-utils.occ}
This file contains utilities common to the test of the Occam implementation of
the adder and the multiplexer.
\begin{lstlisting}
include(`../kroc/test-utils.occ') dnl
\end{lstlisting}
\newpage

\subsubsection{test-adder.occ}
This is Occam code to test the ripple carry adder implementation.
\begin{lstlisting}
include(`../kroc/test-adder.occ') dnl
\end{lstlisting}
\newpage

\subsubsection{test-mux.occ}
The test code of the $3-1$ multiplexer follows:
\begin{lstlisting}
include(`../kroc/test-mux.occ') dnl
\end{lstlisting}
\newpage

\lstset{language=c, keywordstyle=\bf}

\subsubsection{test-reference.c}
This is a reference implementation in c of the adder and the $3-1$ multiplexer.
The output of this program is used to compare with the output of the Occam
implementations.
\begin{lstlisting}
include(`../kroc/test-reference.c') dnl
\end{lstlisting}
\newpage

\subsubsection{create-input.c}
This program is run to create test data for input to the reference and Occam
implementations of the adder and multiplexer.
\begin{lstlisting}
include(`../kroc/create-input.c') dnl
\end{lstlisting}
\newpage

\end{appendix}

\end{document}

% vi: ft=tex
