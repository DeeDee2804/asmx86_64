#include <iomanip>
#include <iostream>
using namespace std;

int main (int argc, char* argv[])
{
    string bars;
    bars.append(50, '-');

    cout << bars << endl;
    cout << "Command Line Arguments Example" << endl << endl;
    cout << "Total arguments provided: " << argc << endl;
    cout << "The name used to start the program: " << argv[0] << endl;
    if (argc > 1) {
        cout << endl << "The arguments are:" << endl;
        for (int n = 1; n < argc; n++) {
            cout << setw(2) << n << ":" <<
                    argv[n] << endl;
        }
    }
    cout << endl;
    cout << bars << endl;
    return 0;
}