#include <SFML/Graphics.hpp>
#include <complex>
#include <oneapi/tbb.h>
#include <iostream>
#include <mutex>
#include <fstream>
#include <chrono>
std::mutex myMutex;

using Complex = std::complex<double>;

int mandelbrot_par(Complex const &c)
{
    int i = 0;
    Complex z = c;
    for (; i != 256 && norm(z) < 4.; ++i)
    {
        z = z * z + c;
    }
    return i;
}

sf::Color to_color(int k)
{
    return k < 256 ? sf::Color{static_cast<sf::Uint8>(10 * k), 0, 0}
                   : sf::Color::Black;
}

double mandelbrot_set(int G, bool draw) // used to be main, made to func to test G easier and not draw every time
{
    int const display_width{800};
    int const display_height{800};

    Complex const top_left{-2.2, 1.5};
    Complex const lower_right{0.8, -1.5};
    auto const diff = lower_right - top_left;

    double const delta_x = diff.real() / display_width;
    double const delta_y = diff.imag() / display_height;

    sf::Image image;
    if (draw)
    {
        image.create(display_width, display_height);
    }

    auto t0 = std::chrono::steady_clock::now();

    tbb::simple_partitioner partitioner{};
    tbb::parallel_for(
        tbb::blocked_range2d<size_t>(0, display_width, G, 0, display_height, G), // grainsize of GxG
        [&](const tbb::blocked_range2d<size_t> &range)
        {
            for (unsigned int row = range.rows().begin(); row != range.rows().end(); ++row) // range is unsigned so index is too
            {
                for (unsigned int column = range.cols().begin(); column != range.cols().end(); ++column)
                {

                    int k = mandelbrot_par(top_left + Complex{delta_x * column, delta_y * row});

                    if (draw)
                        image.setPixel(column, row, to_color(k));
                }
            }
        });

    auto t1 = std::chrono::steady_clock::now();

    std::chrono::duration<double> dur = t1 - t0;
    if (draw)
        image.saveToFile("mandelbrot_par.png");

    return dur.count();
}

int main()
{
    int nG = 7;

    int Gs[nG] = {
        1,
        5,
        10,
        15,
        20,
        30,
        100,
    };
    double *durs = new double[nG];

    for (int i = 0; i < nG; i++)
    {
        durs[i] = mandelbrot_set(Gs[i], false);
    }

    // Safe runtinmes to file
    std::ofstream outFile("grainsize_duration.txt");
    if (outFile.is_open())
    {
        outFile << "Grainsize Duration\n"; 
        for (int i = 0; i < nG; i++)
        {
            outFile << Gs[i] << " " << durs[i] << "\n";
        }
        outFile.close();
    }
    else
    {
        std::cerr << "Unable to open file for writing!" << std::endl;
    }

    // Draw Mandelbrot set using the fastest Grainsize
    auto minElementIt = std::min_element(durs, durs + nG);
    int minIndex = std::distance(durs, minElementIt);
    mandelbrot_set(Gs[minIndex], true);
    
    std::cout << "Done!"<< std::endl;

    delete[] durs;
    return 0;
}
