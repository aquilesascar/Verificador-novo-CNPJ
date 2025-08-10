.data
	msgCNPJ: .asciiz "Digite o CNPJ (14 caracteres): "
	cnpj: .space 15
	pesosDv1: .byte 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2
	pesosDv2: .byte 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2
	msgCNPJvalido: .asciiz "Este e um CNPJ valido"
	msgCNPJinvalido: .asciiz "Este e um CNPJ invalido, tente outra vez"
	cnpjCopia: .space 15
	msgCNPJbloqueado: .asciiz "Compra bloqueada por inserção de informação incorreta"
	
.text
	.globl main
main:

	li $s3, 0 #contador de tentativas
	li $s4, 3 #limite máximo de tentativas
tentativas:
	# Imprime a mensagem para o usuario
	li $v0, 4
	la $a0, msgCNPJ
	syscall
	
	# Leitura do CNPJ
	li $v0, 8
	la $a0, cnpj
	li $a1, 15
	syscall
	
	# Armazena os enderecos do CNPJ original e da copia em registradores fixos
	la $s0, cnpj #
	la $s1, cnpjCopia # $s1 -> endereco da copia
	
	# Copia o CNPJ original para a copia
	li $t0, 0 # contador do loop
	li $t1, 14 # limite do loop (14 caracteres)
	copia:
		addu $t2, $s0, $t0 # endereco da fonte + indice
		lb $t3, 0($t2)
		addu $t4, $s1, $t0 # endereco do destino + indice
		sb $t3, 0($t4)
		
		addi $t0, $t0, 1
		bne $t0, $t1, copia
	
	
	li $t1, 0 # contador de 0 a 11
	li $t2, 12 # limite do contador
	li $t3, 0 # valor da soma
	la $t4, pesosDv1 # endereco dos pesos para o DV1
	
	somaDv1:
		addu $t0, $s0, $t1 # Pega o caractere do CNPJ original
		lb $t0, 0($t0)
		
		addi $t0, $t0, -48 # Converte para o valor decimal (ASCII - 48)
		
		addu $t5, $t4, $t1 # Pega o peso do array de pesos
		lb $t5, 0($t5)
		
		mul $t0, $t0, $t5
		add $t3, $t3, $t0
		
		addi $t1, $t1, 1
		bne $t1, $t2, somaDv1
	
	saidaSomaDv1:
	rem $t3, $t3, 11 # Guarda o resto da divisao
	
	li $t9, 11
	# Se o resto for 0 ou 1, o DV é 0
	ble $t3, 1, pdUmZero
	# Se nao, subtrai de 11
	subu $t6, $t9, $t3
	j calculoSegundoDV
	
	pdUmZero:
		li $t6, 0 # Primeiro DV e 0
	
calculoSegundoDV:
	# Converte o 1o DV para ASCII e armazena na copia
	addi $t6, $t6, 48
	addu $t8, $s1, 12 # Endereco da 13a posicao (indice 12)
	sb $t6, 0($t8)
	
	# --- CALCULANDO O SEGUNDO DÍGITO VERIFICADOR ---
	li $t1, 0 # contador de 0 a 12
	li $t2, 13 # limite do contador
	li $t3, 0 # valor da soma
	la $t4, pesosDv2 # endereco dos pesos para o DV2
	
	somaDv2:
		addu $t0, $s1, $t1 
		lb $t0, 0($t0)
		
		addi $t0, $t0, -48
		
		addu $t5, $t4, $t1
		lb $t5, 0($t5)
		
		mul $t0, $t0, $t5
		add $t3, $t3, $t0
		
		addi $t1, $t1, 1
		bne $t1, $t2, somaDv2
	
	saidaSomaDv2:
	rem $t3, $t3, 11
	
	li $t9, 11
	# Se o resto for 0 ou 1, o DV e 0
	ble $t3, 1, pdUmZeroDv2
	# Se nao, subtrai de 11
	subu $t7, $t9, $t3
	j fimDv2
	
	pdUmZeroDv2:
		li $t7, 0 # Segundo DV e 0
	
fimDv2:
	# Converte o 2o DV para ASCII e armazena na copia
	addi $t7, $t7, 48
	addu $t8, $s1, 13 # Endereco da 14a posicao (indice 13)
	sb $t7, 0($t8)
	
	
	li $t0, 0 # indice para a comparacao
	li $t4, 14 # limite do loop (14 caracteres)
	
	compararCNPJ:
		# Pega o caractere do CNPJ original
		addu $t1, $s0, $t0
		lb $t2, 0($t1)
		
		# Pega o caractere do CNPJ com DVs calculados
		addu $t1, $s1, $t0
		lb $t3, 0($t1)
		
		# Se forem diferentes, pula para 'diferente'
		bne $t3, $t2, diferente
		
		addi $t0, $t0, 1
		blt $t0, $t4, compararCNPJ
	
	# Se o loop terminar sem diferencas, o CNPJ e valido
	igual:
		li $v0, 4
		la $a0, msgCNPJvalido
		syscall
		j fim
		
	diferente:
	
		addi $s3,$s3,1
		beq $s3, $s4, bloqueado
		li $v0, 4
		la $a0, msgCNPJinvalido
		syscall		
		j tentativas
		
		
	bloqueado:
		li $v0, 4
		la $a0, msgCNPJbloqueado
		syscall
		j fim

		
fim:
	li $v0, 10
	syscall
