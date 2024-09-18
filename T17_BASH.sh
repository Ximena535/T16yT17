#!/bin/bash
# Umbrales de alerta
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Función para verificar el uso del CPU
check_cpu() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}')
    echo "Uso del CPU: $cpu_usage%"
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        echo "ALERTA: Uso del CPU por encima del $CPU_THRESHOLD%"
    fi
}

# Función para verificar el uso de la memoria
check_memory() {
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Uso de la memoria: $memory_usage%"
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "ALERTA: Uso de la memoria por encima del $MEMORY_THRESHOLD%"
    fi
}

# Función para verificar el uso del disco
check_disk() {
    disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    echo "Uso del disco: $disk_usage%"
    if [ $disk_usage -gt $DISK_THRESHOLD ]; then
        echo "ALERTA: Uso del disco por encima del $DISK_THRESHOLD%"
    fi
}

# Función para verificar el rendimiento del sistema con vmstat
check_vmstat() {
    vmstat 1 1
}

# Función para verificar el rendimiento del disco con iostat
check_iostat() {
    iostat -dx 1 5
}

# Ejecutar las verificaciones
check_cpu
check_memory
check_disk
check_vmstat
check_iostat
