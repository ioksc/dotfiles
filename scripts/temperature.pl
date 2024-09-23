#!/usr/bin/perl
use strict;
use warnings;

# Ejecutar el comando sensors -u y capturar la salida
my $output = `sensors -u`;

# Variables para almacenar las temperaturas
my $gpu_temp;
my @cpu_temps;

# Analizar la salida línea por línea
foreach my $line (split /\n/, $output) {
    # Obtener la temperatura de la GPU
    if ($line =~ /^  temp1_input:\s+(\d+\.\d+)$/) {
        $gpu_temp = $1;
    }
    
    # Obtener las temperaturas de los núcleos de la CPU
    if ($line =~ /^  temp\d+_input:\s+(\d+\.\d+)$/) {
        push @cpu_temps, $1;
    }
}

# Calcular la temperatura promedio de la CPU
my $cpu_avg = sprintf("%.2f", sum(@cpu_temps) / scalar(@cpu_temps));

# Imprimir los resultados
print "Temperatura de la GPU: $gpu_temp°C\n";
print "Temperaturas de los núcleos de la CPU: " . join(", ", @cpu_temps) . "°C\n";
print "Temperatura promedio de la CPU: $cpu_avg°C\n";

# Función para calcular la suma de un array
sub sum {
    my $total = 0;
    $total += $_ for @_;
    return $total;
}
