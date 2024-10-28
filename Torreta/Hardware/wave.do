onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /torreta_tb/seletor_hexa
add wave -noupdate -divider -height 25 GERAIS
add wave -noupdate -height 20 /torreta_tb/clock
add wave -noupdate -height 20 /torreta_tb/caso
add wave -noupdate -height 20 /torreta_tb/reset
add wave -noupdate -height 20 /torreta_tb/ligar
add wave -noupdate -height 20 /torreta_tb/echo
add wave -noupdate -height 20 /torreta_tb/conta_municao
add wave -noupdate -height 20 /torreta_tb/trigger
add wave -noupdate -height 20 /torreta_tb/saida_serial
add wave -noupdate -height 20 /torreta_tb/ameaca_detectada
add wave -noupdate -height 20 /torreta_tb/fim_posicao
add wave -noupdate /torreta_tb/pwm_base
add wave -noupdate /torreta_tb/pwm_recarga
add wave -noupdate -divider -height 25 {DISTANCIA E ANGULO}
add wave -noupdate -color RED -height 20 -itemcolor RED -radix hexadecimal /torreta_tb/DUT/FD/unidade
add wave -noupdate -color RED -height 20 -itemcolor RED -radix hexadecimal /torreta_tb/DUT/FD/dezena
add wave -noupdate -color RED -height 20 -itemcolor RED -radix hexadecimal /torreta_tb/DUT/FD/centena
add wave -noupdate -color RED -height 20 -itemcolor RED -radix hexadecimal /torreta_tb/DUT/FD/unidade_angulo
add wave -noupdate -color RED -height 20 -itemcolor RED -radix hexadecimal /torreta_tb/DUT/FD/dezena_angulo
add wave -noupdate -color RED -height 20 -itemcolor RED -radix hexadecimal /torreta_tb/DUT/FD/centena_angulo
add wave -noupdate -divider UC
add wave -noupdate -height 20 -radix hexadecimal /torreta_tb/DUT/UC/Eatual
add wave -noupdate -height 20 /torreta_tb/DUT/UC/girar
add wave -noupdate -height 20 /torreta_tb/DUT/UC/medir
add wave -noupdate -height 20 /torreta_tb/DUT/UC/transmitir
add wave -noupdate -height 20 /torreta_tb/DUT/UC/pronto
add wave -noupdate -height 20 /torreta_tb/DUT/UC/conta_tempo
add wave -noupdate -height 20 /torreta_tb/DUT/UC/armar_disparo
add wave -noupdate -height 20 /torreta_tb/DUT/UC/disparar
add wave -noupdate -height 20 /torreta_tb/DUT/UC/recarregar_disparo
add wave -noupdate -divider {SERVO BASE}
add wave -noupdate -color red -itemcolor red /torreta_tb/DUT/FD/SERVO_BASE/posicao
add wave -noupdate -color red -itemcolor red /torreta_tb/DUT/FD/SERVO_BASE/dut/largura_pwm
add wave -noupdate -divider MUNIÇ~AO
add wave -noupdate /torreta_tb/DUT/FD/CONT_MUNICAO/soma
add wave -noupdate /torreta_tb/DUT/FD/CONT_MUNICAO/sub
add wave -noupdate -radix unsigned /torreta_tb/DUT/FD/CONT_MUNICAO/Q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {281023050 ns} 0} {{Cursor 2} {280002050 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 248
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {438912303 ns}
