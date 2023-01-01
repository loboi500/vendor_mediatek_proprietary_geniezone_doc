import os.path
import sys
import argparse
import re

GZ_TRACING_MARK = "GZT|"

def parse_postfix(postfix_str):
	s = postfix_str

	result = re.split(r"\|", s)
	trace_str = " " + result[1] + "|" + result[2] + "|" + result[3] + "|" + result[4]
	cpu = result[5]
	timestamp = result[6]

	return (cpu, timestamp, trace_str)


def parse_prefix(prefix_str, core, timestamp):
	s = prefix_str

	result = re.split(r" ", s)
	result[-1] = timestamp;
	for i in range(len(result)):
		if "[" in result[i]:
			result[i] = result[i][:3]+ core + result[i][4:]

	s = ' '.join(result)
	return s

def main():
	parser = argparse.ArgumentParser(description='systrace parsing for GZ log format')
	parser.add_argument('--input', '-i',
		required=True,
		help='Provide the input file')
	parser.add_argument('--output', '-o',
		required=True,
		help='Provide the output file')

	args = parser.parse_args()

	if not os.path.isfile(args.input) :
		print("Input file not exist.")
		sys.exit(0)

	print("systrace parsing for GZ log format...")

	with open(os.path.abspath(args.input), 'r') as fr:
		with open(os.path.abspath(args.output), 'w') as fw:
			line_count = 0

			for line in fr:
				line = line.rstrip()
				if GZ_TRACING_MARK in line:

					#Replace to draw pic
					#line = line.replace(" ", GZ_TRACING_MARK)
					#line = line.replace(TEE_SCHED_END, TRACING_MARK_WRITE)

					#Split
					result = re.split(r":", line)
					#print(result)


					info = parse_postfix(result[2])
					#print(info[0])
					#print(info[1])
					#print(info[2])

					prefix = parse_prefix(result[0], info[0], info[1])
					#print(prefix)

					#Concat
					line = ':'.join([prefix, result[1], info[2]])
					print(line)

				#Print
				fw.write(line + "\n")

				line_count = line_count + 1

			print("Output lines: " + str(line_count))
			print("Output file: " + os.path.abspath(args.output))


if __name__ == '__main__':
	main()
