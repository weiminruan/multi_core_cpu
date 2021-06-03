#include <iostream>
#include <sstream>
#include <string>
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <bitset>
using namespace std;

int main()
{
	//cout<<bitset<sizeof(char)*4>(-1).to_string()<<endl;
	ifstream infile;
	ofstream outfile;
	infile.open("assembly.txt");
	outfile.open("binary_code.txt");

	string line;
	string words[5];
	string first_word;
	while(getline(infile, line))
	{
		char *token =strtok(&line[0],"\t ,");
		int i=0;
        while (token != NULL) 
            {
                words[i] = token;
                //cout<<words[i]<<endl;
                token =strtok(NULL, "\t ,"); 
                i++;
            }
 		
		if(words[0]=="ah")//add halfword
		{
			outfile<<"00011001000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ahi")//add halfword immedaite
		{
			outfile<<"00011101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="a")//add word
		{
			outfile<<"00011000000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ai")//add word immediate
		{
			outfile<<"00011100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="sfh")//subtract from halfword 
		{
			outfile<<"00001001000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;	
		}
		else if(words[0]=="sfhi")//subtract from halfword immediate
		{
			outfile<<"00001101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;	
		}
		else if(words[0]=="sf")//subtract from word
		{
			outfile<<"00001000000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;	
		}
		else if(words[0]=="sfi")//subtract from word immediate
		{
			outfile<<"00001100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;	
		}
		
		else if(words[0]=="addx")//add extended 
		{
			outfile<<"01101000000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		
		else if(words[0]=="cg")//carry generate
		{
			outfile<<"00011000010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		
		else if(words[0]=="sfx")//subtract from extended
		{
			outfile<<"01101000001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}

		else if(words[0]=="bg")//borrow generate
		{
			outfile<<"00001000010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="clz")//count leading zeros
		{
			outfile<<"01010100101"
			<<bitset<sizeof(char)*7>(stoi("0000000")).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="and")//and
		{
			outfile<<"00011000001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="andc")//and with complement
		{
			outfile<<"01011000001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="andbi")//and byte immediate
		{
			outfile<<"00010110"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="andhi")//and halfword immediate
		{
			outfile<<"00010101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="andi")//and word immediate
		{
			outfile<<"00010100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="or")//or
		{
			outfile<<"00001000001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="orc")//or with complement
		{
			outfile<<"01011001001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="orbi")//or byte immediate
		{
			outfile<<"00000110"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="orhi")//or halfword immediate
		{
			outfile<<"00000101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ori")//or word immediate
		{
			outfile<<"00000100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}

		else if(words[0]=="xor")//exclusive or
		{
			outfile<<"01001000001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="xorbi")//exclusive or byte immediate
		{
			outfile<<"01000110"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="xorhi")//exclusive or halfword immediate
		{
			outfile<<"01000101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="xori")//exclusive or word immediate
		{
			outfile<<"01000100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="nand")//nand
		{
			outfile<<"00011001001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="nor")//nor
		{
			outfile<<"00001001001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="eqv")//equivalent
		{
			outfile<<"01001001001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="selb")//select bits 
		{
			outfile<<"1000"
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[4])).to_string()
			<<endl;
		}
		else if(words[0]=="ceqb")//compare equal byte
		{
			outfile<<"01111010000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ceqh")//compare equal halfword
		{
			outfile<<"01111001000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ceq")//compare equal word
		{
			outfile<<"01111000000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ceqbi")//compare equal byte immediate 
		{
			outfile<<"01111110"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ceqhi")//compare equal halfword immediate
		{
			outfile<<"01111101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cgtb")//compare greater than byte
		{
			outfile<<"01001010000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cgtbi")//compare greater than halfword
		{
			outfile<<"01001001000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cgt")//compare greater than word
		{
			outfile<<"01001000000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cgtbi")//compare greater than byte immedaite
		{
			outfile<<"01001110"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cgthi")//compare greater than halfword immediate
		{
			outfile<<"01001101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cgti")//compare greater than word immediate
		{
			outfile<<"01001100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="clgtb")//Compare logical greater than byte
		{
			outfile<<"01011010000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="clgth")//Compare logical greater than halfword
		{
			outfile<<"01011001000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="clgt")//Compare logical greater than word
		{
			outfile<<"01011000000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="clgtbi")//Compare logical greater than byte immediate
		{
			outfile<<"01011110"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="clgthi")//Compare logical greater than halfword immediate
		{
			outfile<<"01011101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="clgti")//Compare logical greater than word immediate
		{
			outfile<<"01011100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="nop")//Nop execute
		{
			outfile<<"01000000001"
			<<bitset<sizeof(char)*7>(stoi("0")).to_string()
			<<bitset<sizeof(char)*7>(stoi("0")).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ilh")//Immediate Load Halfword
		{
			outfile<<"010000011"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ilhu")//Immediate Load Halfword upp
		{
			outfile<<"010000010"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="il")//Immediate Load Word
		{
			outfile<<"010000001"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="ila")//Immediate load address
		{
			outfile<<"0100001"
			<<bitset<sizeof(char)*18>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		//simple fixed 2

		else if(words[0]=="shlh")//Shift left halfword
		{
			outfile<<"00001011111"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="shlhi")//Shift left halfword immediate
		{
			outfile<<"00001111111"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="shl")//Shift left word
		{
			outfile<<"00001011011"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="shli")//Shift left word Immediate
		{
			outfile<<"00001111011"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="roth")//Rotate halfword
		{
			outfile<<"00001011100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rothi")//Rotate halfword immediate
		{
			outfile<<"00001111100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rot")//Rotate word
		{
			outfile<<"00001011000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="roti")//Rotate word immediate
		{
			outfile<<"00001111000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rothm")//Rotate and mask halfword
		{
			outfile<<"00001011101"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rothmi")//Rotate and mask halfword immediate
		{
			outfile<<"00001111101"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotm")//Rotate and mask word 
		{
			outfile<<"00001011001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotmi")//Rotate and mask word immediate
		{
			outfile<<"00001111001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotmah")//Rotate and mask algebraic halfword
		{
			outfile<<"00001011110"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotmahi")//Rotate and mask algebraic halfword immediate
		{
			outfile<<"00001011110"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotma")//Rotate and mask algebraic word 
		{
			outfile<<"00001011010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotmai")//Rotate and mask algebraic word immediate
		{
			outfile<<"00001111010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		//single precision
		else if(words[0]=="fa")//Floating add
		{
			outfile<<"01011000100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="fs")//Floating subtract
		{
			outfile<<"01011000101"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="fm")//Floating multiply
		{
			outfile<<"01011000110"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="fma")//Floating mul and add
		{
			outfile<<"1110"
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[4])).to_string()
			<<endl;
		}
		else if(words[0]=="fms")//Floating mul and sub
		{
			outfile<<"1111"
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[4])).to_string()
			<<endl;
		}
		else if(words[0]=="fceq")//Floating compare equal
		{
			outfile<<"01111000010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="fcmeq")//Floating compare magnitude equal
		{
			outfile<<"01111001010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="fcgt")//Floating compare greater than
		{
			outfile<<"01011000010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="fcmgt")//Floating compare magnitude greater than
		{
			outfile<<"01011001010"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="mpy")//multiply
		{
			outfile<<"01111000100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="mpyu")//Multiply unsigned
		{
			outfile<<"01111001100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="mpyi")//Multiply immediate
		{
			outfile<<"01110100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="mpyi")//Multiply unsigned immediate
		{
			outfile<<"01110101"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="mpyh")//Multiply high
		{
			outfile<<"01111000101"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="mpys")//Multiply and shift right
		{
			outfile<<"01111000111"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="mpya")//Mul and add
		{
			outfile<<"1100"
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[4])).to_string()
			<<endl;
		}
		else if(words[0]=="csflt")//Convert signed integer to floating
		{
			outfile<<"0111011010"
			<<bitset<sizeof(char)*8>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cflts")//Convert floating to signed integer
		{
			outfile<<"0111011000"
			<<bitset<sizeof(char)*8>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cuflt")//Convert unsigned integer to floating
		{
			outfile<<"0111011011"
			<<bitset<sizeof(char)*8>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="cfltu")//Convert floating to unsigned integer
		{
			outfile<<"0111011001"
			<<bitset<sizeof(char)*8>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		//byte
		else if(words[0]=="cntb")//Count ones in Bytes
		{
			outfile<<"01010110100"
			<<bitset<sizeof(char)*7>(stoi("0")).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="sumb")//Sum byte
		{
			outfile<<"01001010011"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="avgb")//Average bytes
		{
			outfile<<"00011010011"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="absdb")//Absolute differences of Bytes
		{
			outfile<<"00001010011"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		//permute
		else if(words[0]=="shlqbi")//Shift left quadword by Bits
		{
			outfile<<"00111011011"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="shlqbi")//Shift left quadword by Bits immediate
		{
			outfile<<"00111111011"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="shlqby")//Shift left quadword by bytes
		{
			outfile<<"00111011111"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="shlqbyi")//Shift left quadword by bytes immediate
		{
			outfile<<"00111111111"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotqbi")//Rotate quadword by bits
		{
			outfile<<"00111011000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotqbii")//Rotate quadword by bits immediate
		{
			outfile<<"00111111000"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotqby")//Rotate quadword by bytes
		{
			outfile<<"00111011100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotqbyi")//Rotate quadword by bytes immediate
		{
			outfile<<"00111111100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotqmby")//Rotate and Mask quadword by bytes
		{
			outfile<<"00111011101"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="rotqmbyi")//Rotate quadword by bytes immediate
		{
			outfile<<"00111111101"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="Rotqmbi")//Rotate and Mask quadword by bits
		{
			outfile<<"00111011001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="Rotqmbii")//Rotate and Mask quadword by bits immediate
		{
			outfile<<"00111111001"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		//load store
		else if(words[0]=="lqd")//Load quadword(d-form)
		{
			outfile<<"00110100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
			//cout<<words[3]<<endl;
			//cout<<words[2]<<endl;
			//cout<<words[1]<<endl;
		}
		else if(words[0]=="lqx")//Load quadword(x-form)
		{
			outfile<<"00111000100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="stqd")//Store quadword(d-form)
		{
			outfile<<"00100100"
			<<bitset<sizeof(char)*10>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="stqx")//Store quadword(x-form)
		{
			outfile<<"00101000100"
			<<bitset<sizeof(char)*7>(stoi(words[3])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="inop")//No operation (load)
		{
			outfile<<"00000000001"
			<<bitset<sizeof(char)*21>("0").to_string()
			<<endl;
		}
		//branch
		else if(words[0]=="br")//Branch relative
		{
			outfile<<"001100100"
			<<bitset<sizeof(char)*16>(stoi(words[1])).to_string()
			<<"0000000"
			<<endl;
		}
		else if(words[0]=="bra")//Branch absolute
		{
			outfile<<"001100000"
			<<bitset<sizeof(char)*16>(stoi(words[1])).to_string()
			<<"0000000"
			<<endl;
		}
		else if(words[0]=="bi")//Branch indirect
		{
			outfile<<"001101010000000000"
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<"0000000"
			<<endl;
		}
		else if(words[0]=="brsl")//Branch relative and set link
		{
			outfile<<"001100110"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="brasl")//Branch absolute and set link
		{
			outfile<<"001100010"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="brnz")//Branch if not zero word
		{
			outfile<<"001000010"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="brz")//Branch if zero word
		{
			outfile<<"001000000"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="brhnz")//Branch if not zero halfword
		{
			outfile<<"001000110"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="brhz")//Branch if zero halfword
		{
			outfile<<"001000100"
			<<bitset<sizeof(char)*16>(stoi(words[2])).to_string()
			<<bitset<sizeof(char)*7>(stoi(words[1])).to_string()
			<<endl;
		}
		else if(words[0]=="stop")//Stop and signal
		{
			outfile<<"00000000000"
			<<bitset<sizeof(char)*21>(stoi("0")).to_string()

			<<endl;
		}
		else
		{
			//cout<<"error!"<<endl;
		}

		
	}
	infile.close();
	return 0;

}
