import os
import sys
import time
import subprocess
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

PORT = 8089
OUTPUT_DIR = os.path.abspath("docs/prints_apresentacao")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 1. Iniciar servidor local
print(f"Iniciando servidor HTTP local na porta {PORT}...")
server_process = subprocess.Popen([sys.executable, "-m", "http.server", str(PORT)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(1.5)

try:
    print("Configurando Chrome Headless com 2x DPI...")
    options = Options()
    options.add_argument('--headless=new')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--force-device-scale-factor=2')
    options.add_argument('--hide-scrollbars')

    driver = webdriver.Chrome(options=options)

    # Lista de Capturas Mobile (390x844 - iPhone 14/15)
    mobile_screens = [
        ("tela1", "mobile_01_login.png", "Tela 01 — Login & Termo LGPD (Art. 14)"),
        ("tela2", "mobile_02_professora_diario.png", "Tela 02 — Painel da Professora: Diário Rápido em Lote"),
        ("tela3", "mobile_03_pais_agenda.png", "Tela 03 — Visão dos Pais: Agenda do Dia + Insumos"),
        ("tela4", "mobile_04_informes_medicacao.png", "Tela 04 — Informes & Controle de Medicamentos"),
        ("tela5", "mobile_05_portaria.png", "Tela 05 — Portaria Segura: Saída com PIN #8492 e QR Code"),
    ]

    print("\n--- Gerando Capturas Mobile (390x844 @ 2x DPI) ---")
    driver.set_window_size(390, 844)

    for screen_id, filename, desc in mobile_screens:
        url = f"http://127.0.0.1:{PORT}/showcase.html?screen={screen_id}&view=mobile&capture=true"
        print(f"Capturando {filename} ({desc})...")
        driver.get(url)
        time.sleep(2) # Garantir renderização do Tailwind e ícones Lucide
        filepath = os.path.join(OUTPUT_DIR, filename)
        driver.save_screenshot(filepath)
        size_kb = os.path.getsize(filepath) / 1024
        print(f"✓ Salvo: {filepath} ({size_kb:.1f} KB)")

    # Capturas Desktop (1366x768 @ 2x DPI)
    desktop_screens = [
        ("tela2", "desktop_01_painel_geral.png", "Desktop 01 — Painel Geral Coordenação / Diário"),
        ("tela5", "desktop_02_portaria.png", "Desktop 02 — Central da Portaria Segura"),
    ]

    print("\n--- Gerando Capturas Desktop (1366x768 @ 2x DPI) ---")
    driver.set_window_size(1366, 768)

    for screen_id, filename, desc in desktop_screens:
        url = f"http://127.0.0.1:{PORT}/showcase.html?screen={screen_id}&view=desktop&capture=true"
        print(f"Capturando {filename} ({desc})...")
        driver.get(url)
        time.sleep(2)
        filepath = os.path.join(OUTPUT_DIR, filename)
        driver.save_screenshot(filepath)
        size_kb = os.path.getsize(filepath) / 1024
        print(f"✓ Salvo: {filepath} ({size_kb:.1f} KB)")

    driver.quit()
    print("\n✓ Todas as capturas de tela foram geradas com sucesso!")

finally:
    print(f"Encerrando servidor HTTP local (PID {server_process.pid})...")
    server_process.terminate()
    server_process.wait()
