import sys, subprocess
from PyQt5.QtWidgets import (QApplication, QWidget, QVBoxLayout, QHBoxLayout, 
                             QLabel, QPushButton, QStackedWidget, QRadioButton, 
                             QButtonGroup, QCheckBox, QMessageBox)

class SetupWizard(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("AlyaOS Kurulum Sihirbazı")
        self.setFixedSize(500, 400)
        self.layout = QVBoxLayout()
        self.setLayout(self.layout)
        self.pages = QStackedWidget()
        self.layout.addWidget(self.pages)
        self.create_welcome_page()
        self.create_store_page()

        btn_layout = QHBoxLayout()
        self.btn_back = QPushButton("< Geri")
        self.btn_next = QPushButton("İleri >")
        self.btn_back.setEnabled(False)
        self.btn_back.clicked.connect(self.go_back)
        self.btn_next.clicked.connect(self.go_next)
        btn_layout.addWidget(self.btn_back)
        btn_layout.addStretch()
        btn_layout.addWidget(self.btn_next)
        self.layout.addLayout(btn_layout)

    def create_welcome_page(self):
        page = QWidget()
        layout = QVBoxLayout()
        title = QLabel("AlyaOS'a Hoş Geldiniz!")
        title.setStyleSheet("font-size: 20px; font-weight: bold; color: #f5c2e7;")
        desc = QLabel("Sisteminizi kişiselleştirmek için adımları takip edin.")
        layout.addWidget(title)
        layout.addWidget(desc)
        layout.addStretch()
        page.setLayout(layout)
        self.pages.addWidget(page)

    def create_store_page(self):
        page = QWidget()
        layout = QVBoxLayout()
        title = QLabel("Uygulama Mağazası Seçimi")
        title.setStyleSheet("font-size: 16px; font-weight: bold;")
        layout.addWidget(title)
        self.radio_gnome = QRadioButton("AlyaOS Mağaza (GNOME Software + Flatpak)")
        self.radio_gnome.setChecked(True)
        layout.addWidget(self.radio_gnome)
        layout.addStretch()
        page.setLayout(layout)
        self.pages.addWidget(page)

    def go_next(self):
        current = self.pages.currentIndex()
        if current < self.pages.count() - 1:
            self.pages.setCurrentIndex(current + 1)
            self.btn_back.setEnabled(True)
            if self.pages.currentIndex() == self.pages.count() - 1:
                self.btn_next.setText("Tamamla")
        else:
            self.close()

    def go_back(self):
        current = self.pages.currentIndex()
        if current > 0:
            self.pages.setCurrentIndex(current - 1)
            self.btn_next.setText("İleri >")
            if self.pages.currentIndex() == 0:
                self.btn_back.setEnabled(False)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    wizard = SetupWizard()
    wizard.show()
    sys.exit(app.exec_())
