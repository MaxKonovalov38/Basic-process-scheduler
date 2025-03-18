#!/usr/bin/env perl
use strict;
use warnings;

use DateTime;
use Log::Log4perl;

## Основная СПРАВКА
my $param_name = shift;
my $data_help = <<EOF;
## Main HELP ##
>> perl main.pl [-h|--help]

## Basic process scheduler ##
.---------------------minute (0-30)
| .-------------------hour (0-23)
| | .-----------------day of month (1-31)
| | | .---------------month (1-12)
| | | | .-------------day of week (0-6)
| | | | |
* * * * * -c [command]

## Example ##
>> * 2 10 * * -c cat hello.txt
>> 2 12 * * 0 -c tac hello.txt >> text.txt
EOF

## Проверка параметров
if ( ($param_name eq '-h') || ($param_name eq '--help') ) {
	print $data_help;
	exit;
} elsif ($param_name) {
	print "perl main.pl [-h|--help]\n";
	exit;
}

## Получение входных данных
my $str_input = (<STDIN>);
chomp($str_input);
if ((length $str_input) < 1) {
	print $data_help . "\n";
	exit;
}

## Преобразовать строку на дату и команды
# Разделение строку по параметру [date_time + command]
my ($str_dt, $str_com) = split / -c /, $str_input;

convert_str_dt_template($str_dt);
executing_commands($str_com);

## Преобразовать строку к дата-время шаблону
sub convert_str_dt_template {
	my $str_dt = shift;

	# Разделение строки по параметру [date_time]
	my @arr_dt = split / /, $str_dt;
	if (scalar @arr_dt != 5) {
		print "[** ERROR **] -- Invalid length of array!\n";
		exit;
	}

	# Проверка на правильность ввода
	foreach my $item (@arr_dt) {
		if ($item !~ /^\d+$/) {
			print "[** ERROR **] -- Invalid input data!\n";	
			exit;
		}
	}	
}

## Выполнение команд
sub executing_commands {
	my $str_command = shift;

	# Разделение строки по параметру [command]
	my @arr_command = split / /, $str_command;
	system(@arr_command);
}

__END__
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
print $wday . "\n";