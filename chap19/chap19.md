# Parallel Processing
**1/ Explain the difference between concurrency and parallel processing**

Parallel processing differs with the concurrency about the definition. While parallel processing implies that processes are simultaneously executing, the concurrency means that multiple different process run simultaneously making progress.

**2/ Name the two common approaches to parallel computations.**

They are:
- Distributed computing
- Multiprocessing

**3/ In distributed processing, where might the parallel computations take place?**

The computation could be assigned to multiple nodes in a network and they will run in parallel and send back the result to the master node, then it will be assigned new subtask if needed.

**4/ Provide the names of two examples of large distributed computing projects. Include a one-sentence description of each.**

The first one is **Folding@home** project that research about how to simulate protein folding, computational drug design and other types of molecular dynamics.<br>
The second one is **Seti@home** project that is a scientific experiment in the search of Extraterrestrial Intelligence.

**5/ In multiprocessing, where might the parallel computations take place?**

The computations might run in parallel in different cores of the computer.

**6/ Provide one advantage and one disadvantage of the distributed computing approach to parallel processing.**

*Advantage*: can be scaled up easily via the new connections of the network<br>
*Disadvantage*: is limited the processing time by the internet connection speed.

**7/ Provide one advantage and one disadvantage of the multiprocessing approach to parallel processing.**

*Advantage*: the limitations of network communication do not apply for thread computation<br>
*Disadvantage*: the limited number of cores in the CPU chips make it is hard to scale up largely.

**8/ Explain what a race condition is.**

It happens when two parallel thread running ovelapped each other and simultaneously change the value of variables.

**9/ Will a race condition occur when a shared variable is read by multiple simultaneously executing threads? Explain why or why not.**

No, if only the variable's value is being changed, the race condition will happen.

**10/ Will a race condition occur when a shared variable is written by multiple simultaneously executing threads? Explain why or why not.**

Yes, the simultaneous thread could overwrite the value of the shared variable in a wrong way which make final result is not as expected.
