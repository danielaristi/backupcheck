#!/bin/ruby

load 'insertpjtodb.rb'
load 'getproject.rb'

# revisa que no existan proyectos duplicados en el amanda
##########checkDuplicateAmanda('amanda','amanda-db')

#Actualiza la lista de proyectos dentro de 
##getAmandaProjects('amanda')
##getAmandaProjects('amanda-db')
getBarmanProjects('barman')

#extrae y prueba un backup

j=0
while j<=30
getNextProject
j=j+1
end



