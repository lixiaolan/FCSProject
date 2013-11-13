#include <iostream>  /* cout */
#include <string>   /* string */
#include <sstream>  /* istringstream, convert */
#include <fstream> /* ifstream */
#include <vector> /* vector */
#include <cmath> /* floor, pow */
#include <ctime>  /* clock */

using namespace std;

int main()  {
    
    //Read data from the file.
    string line;
    vector <double> data;
    double d;
    size_t count;
    ifstream infile;
    
    //convert data from string to double 
    infile.open("Data.out");
    while (infile.eof() == 0)  {
        getline (infile, line);
        istringstream convert(line);
        if ( !(convert >> d) ){
            cout << "Error in reading data!" << endl;
        }
        else data.push_back(d);
    }    
    infile.close();
    
    //Genearte the shift times.
    size_t d_size = data.size();
    int Max = 300;
    vector <double> times;
    times.push_back(1e-10);
    for (double k = 1; k < Max; k++)  {
        times.push_back(times.back() + (1e-10)*pow(2,floor(k/10.0) ) );
    }
    
    //Start the timer clock.
    clock_t start;
    start = clock();
    
    //Run the alg. for each start time.
    double di, dj, t;
    vector <int> cv;
    for ( int k = 0; k < Max; k++ )  {
        t = times[k];
        int i = 0;
        int j = 0;
        count = 0;
        di = data[0];
        dj = data[0]+t;
        while ( 1 )  {
            if (di < dj )  {
                if ( i++ >= d_size ) break;
                di = data[i];
            }
            else if (di > dj )  {
                if ( j++ >= d_size ) break;
                dj = data[j]+t;
            }
            else  {
                count += 1;
                if ( i++ >= d_size ) break;
                di = data[i];
            }
        }
        cv.push_back(count);
    }
    
    cout.precision(15);
    start = clock() - start;
    cout << ((float)start)/CLOCKS_PER_SEC << " seconds to run." << endl;    
}