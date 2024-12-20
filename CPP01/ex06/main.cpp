#include "Harl.hpp"
#include <iostream>

#ifndef EINVAL
# define EINVAL 22
#endif

int main(int argc, char **argv)
{
	Harl		harl;
	std::string input;

	if (argc < 2)
	{
		std::cout << "usage: ./harlFilter <LEVEL>\n";
		return (EINVAL); 
	}
	// do
	// {
	// 	std::cout << "Enter a level: ";
	// 	std::getline(std::cin, input);
	// 	if (std::cin.eof())
	// 	{
	// 		std::cout << std::endl << "Input error, exiting...\n";
	// 		return (1);
	// 	}
		// switch (harl.getLevel(input))
		switch (harl.getLevel(argv[1]))
		{
			default:
			{
				std::cout << "harl is confused and unfamiliar with this LEVEL of commentary\n";
				return (EINVAL);
			}
			case 0:
				harl.complain(harl.levels[0]);
			case 1:
				harl.complain(harl.levels[1]);
			case 2:
				harl.complain(harl.levels[2]);
			case 3:
				harl.complain(harl.levels[3]);
		}
	// } while (input.compare("exit"));

	return (0);
}
