import serial
import streamlit as st
import time
import threading
import serial.tools.list_ports

# Função para listar portas seriais disponíveis
def listar_portas():
    return [port.device for port in serial.tools.list_ports.comports()]

# Função para configurar a porta serial
def configurar_serial(porta, baudrate=115200, timeout=0.3):
    return serial.Serial(
        port=porta,
        baudrate=baudrate,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=timeout
    )

# Função para recarregar a munição
def recarregar_callback():
    enviar_mensagem(reset_toggle, ligar_toggle, fixar_toggle, True)
    enviar_mensagem(reset_toggle, ligar_toggle, fixar_toggle, False)
    
# Função para criar a mensagem de 1 byte
def criar_mensagem(bool1, bool2, bool3, bool4):
    print("DADOS:", bool1, bool2, bool3, bool4)
    mensagem = (bool4 << 3) | (bool3 << 2) | (bool2 << 1) | (bool1)
    return mensagem

def enviar_mensagem(reset_toggle_, ligar_toggle_, fixar_toggle_, recarregar_button_):
    mensagem = criar_mensagem(reset_toggle_, ligar_toggle_, fixar_toggle_, recarregar_button_)
    print("MENSAGEM:", mensagem)
    if serial_conn.is_open:
        print("MENSAEM:", bytes([mensagem]))
        serial_conn.write(bytes([mensagem]))  # Transmite a mensagem como um único byte
        st.success(f"Mensagem transmitida: {mensagem}")
    else:
        st.error("A conexão serial não está aberta.")
# Interface Streamlit
st.title("TORRETA: CENTRAL DE CONTROLE")

# Seção de configuração da porta serial
st.sidebar.header("Configuração da Porta Serial")
portas_disponiveis = listar_portas()
porta_selecionada = st.sidebar.selectbox("Porta Serial", portas_disponiveis)
baudrate = 115200  # Baudrate padrão

# Botão de conexão
if st.sidebar.button("Conectar"):
    if porta_selecionada:
        try:
            serial_conn = configurar_serial(porta_selecionada, baudrate)
            st.session_state["serial_conn"] = serial_conn
            st.success(f"Conectado à {porta_selecionada} com {baudrate} bauds.")
        except serial.SerialException as e:
            st.error(f"Erro ao conectar: {e}")
    else:
        st.error("Nenhuma porta selecionada.")

# Verifica se a conexão foi estabelecida
if "serial_conn" in st.session_state:
    serial_conn = st.session_state["serial_conn"]


    # Switches para 3 booleanos
    columns = st.columns(2)
    with columns[0]:
        reset_toggle = st.toggle("RESETAR TORRETA",
                                 on_change=lambda: enviar_mensagem(not reset_toggle, ligar_toggle, fixar_toggle, recarregar_button))
        ligar_toggle = st.toggle("LIGAR TORRETA", disabled=reset_toggle,
                                 on_change=lambda: enviar_mensagem(reset_toggle, not ligar_toggle, fixar_toggle, recarregar_button))
        fixar_toggle = st.toggle("FIXAR POSIÇÃO DA TORRETA", disabled=reset_toggle,
                                 on_change=lambda: enviar_mensagem(reset_toggle, ligar_toggle, not fixar_toggle, recarregar_button))
    with columns[1]:
        recarregar_button = st.button("CARREGAR MUNIÇÃO", disabled=reset_toggle,
                                      on_click=recarregar_callback
                                      )
    
    # Leitura de dados da porta serial
    def leitura_continua():
        while True:
            if serial_conn.is_open:
                try:
                    dados_recebidos = serial_conn.read(10)  # Lê até 10 bytes
                    print(dados_recebidos)
                    if dados_recebidos:
                        st.success(f"Dados recebidos: {dados_recebidos}")
                except serial.SerialException as e:
                    st.error(f"Erro ao ler dados: {e}")
            else:
                st.error("A conexão serial não está aberta.")
            time.sleep(10)  # Aguarda 1 segundo antes de ler novamente

    # if "leitura_thread" not in st.session_state:
    #     leitura_thread = threading.Thread(target=leitura_continua, daemon=True)
    #     leitura_thread.start()
    #     st.session_state["leitura_thread"] = leitura_thread

    # Botão para desconectar
    if st.button("Desconectar"):
        if serial_conn.is_open:
            serial_conn.close()
        st.session_state.pop("serial_conn", None)
        st.success("Conexão encerrada.")

else:
    st.info("Conecte-se a uma porta serial para iniciar a comunicação.")
