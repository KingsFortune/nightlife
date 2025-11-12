const app = new Vue({
  el: '#app',
  data: {
    ui: false,
    isInVehicle: false,
    showSpeedometer: false,
    health: 0,
    armor: 0,
    hunger: 0,
    thirst: 0,
    stress: 0,
    playerName: 'NETRUNNER',
    playerLevel: 24,
    playerClass: 'STREET KID',
    location: 'NIGHT CITY',
    sector: 'SECTOR 7 • WATSON',
    // Konum bilgileri
    currentLocation: {
      street: 'VESPUCCI BLVD',
      district: 'LITTLE SEOUL • DISTRICT 7',
      coordinates: {
        x: 3478,
        y: 1205
      }
    },
    cash: 15420,
    blackMoney: 5000,
    bankMoney: 185000,
    systemStatus: 'ONLINE',
    speed: 0,
    prevSpeed: 0, // Önceki hız değeri (hız değişimi hesaplamaları için)
    speedUpdateTime: Date.now(), // Son hız güncelleme zamanı
    maxSpeed: 220,
    fuel: 100, // Yakıt seviyesi (0-100)
    nos: 100,  // NOS seviyesi (0-100)
    nosActive: false, // NOS kullanım durumu
    rpm: 800, // Motor devri
    maxRpm: 8000, // Maksimum motor devri
    currentGear: 'P', // Mevcut vites (P,R,N,D veya 1-6)
    engineTemp: 75, // Motor sıcaklığı (celsius)
    
    // Vehicle Status Indicators
    seatbeltOn: false, // Kemer durumu
    cruiseOn: false, // Cruise control durumu  
    doorsLocked: false, // Kapı kilidi durumu
    
    // Silah bilgileri
    hasWeapon: false, // Silah var mı?
    isReloading: false, // Silah yeniden dolduruluyor mu?
    currentWeapon: {
      name: 'NO WEAPON EQUIPPED',
      category: 'NONE',
      icon: 'fas fa-ban',
      ammo: 0,
      maxAmmo: 0,
      ammoType: 'NO AMMO',
      damage: 0,
      range: 0
    },
    weaponInventory: [],

    // UI Animasyon Durumları
    locationUpdating: false,        // Lokasyon güncelleniyor mu? (yeni)
    isWeaponLoading: false,         // Silah yükleniyor mu?
    isAppLoaded: false,             // Uygulama tamamen yüklendi mi?
    animationQueue: [],             // Animasyon kuyruğu
    isAccelerating: false,
    isDecelerating: false,
    lastRpm: 0,
    lastSpeed: 0,
    rpmChangeRate: 0,
    speedChangeRate: 0,
    lastSpeedUpdateTime: Date.now(),
    lastRpmUpdateTime: Date.now(),
  },
  methods: {
    handleEventMessage(event) {
      const item = event.data;
      
      // Status.lua Message Handler
      if (item.action) {
        switch (item.action) {
          case 'UPDATE_HEALTH':
            if (item.data && typeof item.data.health !== 'undefined') {
              this.health = Math.max(0, Math.min(100, Number(item.data.health)));
            }
            break;
            
          case 'UPDATE_ARMOR':
            if (item.data && typeof item.data.armor !== 'undefined') {
              this.armor = Math.max(0, Math.min(100, Number(item.data.armor)));
            }
            break;
            
          case 'UPDATE_NEEDS':
            if (item.data) {
              if (typeof item.data.hunger !== 'undefined') {
                this.hunger = Math.max(0, Math.min(100, Number(item.data.hunger)));
              }
              if (typeof item.data.thirst !== 'undefined') {
                this.thirst = Math.max(0, Math.min(100, Number(item.data.thirst)));
              }
            }
            break;
            
          case 'UPDATE_STRESS':
            if (item.data && typeof item.data.stress !== 'undefined') {
              this.stress = Math.max(0, Math.min(100, Number(item.data.stress)));
            }
            break;
            
          case 'UPDATE_LOCATION':
            if (item.data) {
              const street = item.data.street || 'UNKNOWN STREET';
              const district = item.data.district || 'UNKNOWN DISTRICT';
              const x = item.data.coordinates ? item.data.coordinates.x : undefined;
              const y = item.data.coordinates ? item.data.coordinates.y : undefined;
              
              // Doğrudan verileri güncelle, animasyon olmadan
              if (street !== this.currentLocation.street) {
                this.currentLocation.street = street;
                
                // Direkt DOM güncellemesi yap
                const locationBar = document.getElementById('new-location-bar');
                if (locationBar) {
                  const streetEl = locationBar.querySelector('.loc-street');
                  if (streetEl) {
                    streetEl.textContent = street;
                  }
                }
              }
              
              // District ve koordinatları güncelle
              this.currentLocation.district = district;
              if (x !== undefined) this.currentLocation.coordinates.x = x;
              if (y !== undefined) this.currentLocation.coordinates.y = y;
            }
            break;
            
          case 'UPDATE_WEAPON':
            if (item.data) {
              const weaponBar = this.$refs.weaponBar;
              const wasWeaponVisible = this.hasWeapon;
              
              console.log('🔫 WEAPON MESSAGE RECEIVED:', {
                hasWeapon: item.data.hasWeapon,
                weapon: item.data.weapon,
                wasVisible: wasWeaponVisible
              });
              
              // Silah yükleme animasyonu başlat
              this.isWeaponLoading = true;
              
              // Sadece hasWeapon flag'ine bak
              if (item.data.hasWeapon === true) {
                // Silah VAR - göster
                this.hasWeapon = true;
                
                // Silah bilgilerini güncelle (varsa)
                if (item.data.weapon) {
                  this.currentWeapon = {
                    name: item.data.weapon.name || 'UNKNOWN WEAPON',
                    category: item.data.weapon.category || 'UNKNOWN',
                    icon: item.data.weapon.icon || 'fas fa-gun',
                    ammo: Math.max(0, Math.floor(item.data.weapon.ammo || 0)),
                    maxAmmo: Math.max(1, Math.floor(item.data.weapon.maxAmmo || 1)),
                    ammoType: item.data.weapon.ammoType || 'UNKNOWN AMMO',
                    damage: Math.floor(item.data.weapon.damage || 0),
                    range: Math.floor(item.data.weapon.range || 0)
                  };
                }

                if (weaponBar) {
                  weaponBar.style.visibility = 'visible';
                  weaponBar.style.opacity = '0';

                  setTimeout(() => {
                    weaponBar.style.opacity = '1';
                    weaponBar.classList.add('weapon-visible');
                    weaponBar.classList.add('weapon-loading');

                    setTimeout(() => {
                      this.isWeaponLoading = false;
                      weaponBar.classList.remove('weapon-loading');
                    }, 1000);
                  }, 50);
                }
                
                console.log('🔫 Weapon SHOWN:', this.currentWeapon.name);
                
              } else {
                console.log('🔫 NO WEAPON - Hiding weapon bar');
                
                this.hasWeapon = false;
                this.currentWeapon = {
                  name: 'NO WEAPON EQUIPPED',
                  category: 'NONE',
                  icon: 'fas fa-ban',
                  ammo: 0,
                  maxAmmo: 0,
                  ammoType: 'NO AMMO',
                  damage: 0,
                  range: 0
                };

                if (weaponBar) {
                  weaponBar.classList.remove('weapon-visible');
                  weaponBar.style.opacity = '0';

                  setTimeout(() => {
                    weaponBar.style.visibility = 'hidden';
                  }, 600);
                }
                
                console.log('🔫 Weapon HIDDEN');
              }

              setTimeout(() => {
                this.isWeaponLoading = false;
              }, 1500);
            }
            break;
        }
        return;
      }
      
      // Money System Handler - ESX & QBCore Support
      if (item.data && typeof item.data === 'string') {
        try {
          // ESX Money System
          if (item.data === 'ACCOUNT' && item.type && typeof item.amount !== 'undefined') {
            const amount = Math.max(0, Number(item.amount));
            
            switch (item.type) {
              case 'CASH':
                this.cash = amount;
                break;
              case 'BANK':
                this.bankMoney = amount;
                break;
              case 'BLACK_MONEY':
                this.blackMoney = amount;
                break;
            }
            return;
          }
          
          // QBCore Money System
          if (item.data.startsWith('QBSET_') && typeof item.amount !== 'undefined') {
            const accountType = item.data.replace('QBSET_', '');
            const amount = Math.max(0, Number(item.amount));
            
            switch (accountType) {
              case 'CASH':
                this.cash = amount;
                // console.log('💰 QBCore Cash Updated:', amount);
                break;
              case 'BANK':
                this.bankMoney = amount;
                // console.log('🏦 QBCore Bank Updated:', amount);
                break;
              case 'CRYPTO':
                this.blackMoney = amount;
                // console.log('₿ QBCore Crypto Updated:', amount);
                break;
            }
            return;
          }
        } catch (error) {
          console.error('❌ Money Update Error:', error);
        }
      }
      
      // Legacy Message Handler for Backward Compatibility
      switch (item.data) {
        case 'CAR':
          // Araç verilerini güncelle
          this.speed = item.speed || 0;
          this.rpm = item.rpm || 800;
          this.fuel = item.fuel || 100;
          this.nos = item.nos || 100;
          this.engineTemp = item.engineTemp || 75;
          this.maxSpeed = item.maxSpeed || 220;
          this.maxRpm = item.maxRpm || 8000;
          this.currentGear = this.calculateGear(item.speed, item.gear);
          
          // Vehicle Status Updates
          this.seatbeltOn = item.seatbelt || false;
          this.cruiseOn = item.brakes || false; // client.lua'da cruise "brakes" olarak gönderiliyor
          this.doorsLocked = item.door || false;
          
          // Speedometer'e dinamik CSS class'ları ekle
          this.updateSpeedometerClasses();
          break;
          
        case 'VEHICLE_ENTER':
          this.isInVehicle = true;
          this.showSpeedometer = true;
          this.showSpeedometerAnimation();
          this.updateNewLocationPosition(true);
          this.updateLocationPosition(); // Doğrudan pozisyonu güncelle
          break;
          
        case 'VEHICLE_EXIT':
          this.isInVehicle = false;
          this.hideSpeedometerAnimation();
          this.updateNewLocationPosition(false);
          this.updateLocationPosition(); // Doğrudan pozisyonu güncelle
          break;
          
        case 'CIVIL':
          this.isInVehicle = false;
          break;
          
        case 'STREET':
          // Direkt güncelleme yap, animasyon olmadan
          this.currentLocation.street = item.street || this.currentLocation.street;
          this.currentLocation.district = item.district || this.currentLocation.district;
          
          // Koordinatları güncelle (varsa)
          if (typeof item.x !== 'undefined') this.currentLocation.coordinates.x = item.x;
          if (typeof item.y !== 'undefined') this.currentLocation.coordinates.y = item.y;
          
          // Direkt DOM güncellemesi
          const locationBar = document.getElementById('new-location-bar');
          if (locationBar) {
            const streetEl = locationBar.querySelector('.loc-street');
            if (streetEl && item.street) {
              streetEl.textContent = item.street;
            }
          }
          break;
          
        case 'STATUS':
          if (typeof item.hunger !== 'undefined') {
            this.hunger = Math.max(0, Math.min(100, Math.floor(item.hunger)));
          }
          if (typeof item.thirst !== 'undefined') {
            this.thirst = Math.max(0, Math.min(100, Math.floor(item.thirst)));
          }
          this.ui = true;
          break;
          
        case 'HEALTH':
          if (typeof item.status !== 'undefined') {
            this.health = Math.max(0, Math.min(100, item.status));
          }
          break;
          
        case 'ARMOR':
          if (typeof item.Armour !== 'undefined') {
            this.armor = Math.max(0, Math.min(100, item.Armour));
          }
          break;
          
        case 'STRESS':
          if (typeof item.stress !== 'undefined') {
            this.stress = Math.max(0, Math.min(100, item.stress));
          }
          break;
          
        case 'EXIT':
          // this.ui = item.args;
          break;
          
        case 'PLAYER_LOADED':
          // Karakter yüklendi, UI'ı göster
          this.ui = true;
          console.log('💫 Player Loaded');
          break;
      }
      
      // Direct commands without action field
      if (item.data) {
        // Handle direct commands
        switch(item.data) {
          case 'VEHICLE_ENTER':
            this.isInVehicle = true;
            this.showSpeedometer = true;
            this.showSpeedometerAnimation();
            break;
            
          case 'VEHICLE_EXIT':
            this.isInVehicle = false;
            this.hideSpeedometerAnimation();
            break;
            
          case 'FORCE_LOCATION_REFRESH':
            // Lokasyon çubuğunu zorla yenile - animasyon yapmadan
            this.$nextTick(() => {
              const newLocationBar = document.getElementById('new-location-bar');
              if (newLocationBar) {
                // Sadece pozisyonu güncelle, animasyon yok
                this.updateLocationPosition();
              }
            });
            break;
        }
      }
    },
    
    // Speedometer dinamik CSS class'ları
    updateSpeedometerClasses() {
      const container = document.querySelector('.speedometer-container');
      
      // ÖNEMLİ: Tüm çizgileri sabitleyecek yeni fonksiyonu çağır
      this.fixAllConnectorLines();
      
      if (container) {
        // Mevcut speed class'larını temizle
        container.classList.remove('speed-low', 'speed-medium', 'speed-high');
        
        // Hıza göre class ekle
        if (this.speed < 60) {
          container.classList.add('speed-low');
        } else if (this.speed >= 60 && this.speed < 150) {
          container.classList.add('speed-medium');
        } else {
          container.classList.add('speed-high');
        }
        
        // Container class değişiminden sonra görünürlüğü tekrar garantile
        setTimeout(() => this.fixAllConnectorLines(), 10);
        setTimeout(() => this.fixAllConnectorLines(), 150);
      }
    },
    
    // fixAllConnectorLines fonksiyonunu güçlendirelim - SÜPER GÜÇLÜ
    fixAllConnectorLines() {
      try {
        // SVG elementlerini seç
        const svg = document.querySelector('.speedometer-container svg');
        if (!svg) return;

        // SVG elementinin kendisini görünür yap
        svg.style.cssText = "opacity: 1 !important; visibility: visible !important; display: block !important;";
        svg.setAttribute('opacity', '1');
        svg.setAttribute('visibility', 'visible');
        
        // Tüm connector-lines gruplarını seç
        const connectorLinesGroups = svg.querySelectorAll('.connector-lines');
        if (!connectorLinesGroups || connectorLinesGroups.length === 0) {
          // Grup bulunamasa bile tüm çizgileri bul ve düzelt
          this.fixAllSVGLines(svg);
          return;
        }
        
        // Her bir connector-lines grubunu düzelt
        connectorLinesGroups.forEach(group => {
          // Grubu görünür yap
          group.style.cssText = "opacity: 1 !important; visibility: visible !important; display: block !important; pointer-events: auto !important; position: absolute !important;";
          group.setAttribute('opacity', '1');
          group.setAttribute('visibility', 'visible');
          
          // Grup içindeki tüm çizgileri bul ve düzelt
          const lines = group.querySelectorAll('line');
          if (lines && lines.length > 0) {
            lines.forEach(line => {
              // En güçlü CSS özellikleri
              line.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; display: block !important;";
              
              // SVG özelliklerini doğrudan ayarla
              line.setAttribute('opacity', '1');
              line.setAttribute('visibility', 'visible');
              line.setAttribute('stroke-opacity', '1');
              
              // Çizginin tipine göre kalınlığı ayarla - sabit değerler kullanarak
              if (line.classList.contains('major-line')) {
                line.style.strokeWidth = '0.8';
                line.setAttribute('stroke-width', '0.8');
              } else if (line.classList.contains('medium-line')) {
                line.style.strokeWidth = '0.6';
                line.setAttribute('stroke-width', '0.6');
              } else {
                line.style.strokeWidth = '0.4';
                line.setAttribute('stroke-width', '0.4');
              }
              
              // Animasyonu kaldır - çizgiler sabit kalsın
              line.style.transition = 'none';
              line.style.animation = 'none';
            });
          }
        });
        
        // SVG içindeki tüm line elementlerini düzelt (class'tan bağımsız)
        this.fixAllSVGLines(svg);
        
      } catch (error) {
        console.error("Çizgileri düzeltme hatası:", error);
      }
    },
    
    // Tamamen yeni fonksiyon - SVG içindeki TÜM çizgileri sabitleyen sistem
    fixAllSVGLines(svg) {
      try {
        if (!svg) {
          const speedometerSvg = document.querySelector('.speedometer-container svg');
          if (!speedometerSvg) return;
          svg = speedometerSvg;
        }
        
        // SVG içindeki tüm line elementlerini seç - HİÇBİR istisna olmadan
        const allLines = svg.querySelectorAll('line');
        if (allLines && allLines.length > 0) {
          allLines.forEach(line => {
            // En güçlü CSS özellikleri
            line.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; display: block !important;";
            
            // SVG özelliklerini doğrudan ayarla
            line.setAttribute('opacity', '1');
            line.setAttribute('visibility', 'visible');
            line.setAttribute('stroke-opacity', '1');
            
            // Orijinal stroke-width değerini koru
            const originalWidth = line.getAttribute('stroke-width');
            if (originalWidth) {
              line.style.strokeWidth = originalWidth;
            }
            
            // Animasyonu devre dışı bırak - sabit gösterim
            line.style.transition = 'none !important';
            line.style.animation = 'none !important';
          });
        }
        
        // SVG içindeki tüm g (grup) elementlerini görünür yap
        const allGroups = svg.querySelectorAll('g');
        if (allGroups && allGroups.length > 0) {
          allGroups.forEach(group => {
            group.style.cssText = "opacity: 1 !important; visibility: visible !important; display: block !important;";
            group.setAttribute('opacity', '1');
            group.setAttribute('visibility', 'visible');
          });
        }
        
        // SVG içindeki tüm path elementlerini görünür yap
        const allPaths = svg.querySelectorAll('path');
        if (allPaths && allPaths.length > 0) {
          allPaths.forEach(path => {
            path.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; fill-opacity: 1 !important; display: block !important;";
            path.setAttribute('opacity', '1');
            path.setAttribute('visibility', 'visible');
          });
        }
        
        // SVG içindeki tüm circle elementlerini görünür yap
        const allCircles = svg.querySelectorAll('circle');
        if (allCircles && allCircles.length > 0) {
          allCircles.forEach(circle => {
            circle.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; fill-opacity: 1 !important; display: block !important;";
            circle.setAttribute('opacity', '1');
            circle.setAttribute('visibility', 'visible');
          });
        }
      } catch (error) {
        console.error("SVG elementlerini düzeltme hatası:", error);
      }
    },
    
    // Speedometer animasyonları
    showSpeedometerAnimation() {
      this.showSpeedometer = true;
      this.isInVehicle = true;
      this.updateNewLocationPosition(true); // Lokasyon çubuğunu yukarı taşı
      this.updateLocationPosition(); // %100 güvenlik için doğrudan DOM güncelleme
      
      const speedometerContainer = document.querySelector('.speedometer-container');
      if (speedometerContainer) {
        // Önce speedometer-exit sınıfını temizle
        speedometerContainer.classList.remove('speedometer-exit');
        
        // Görünürlüğü hemen ayarla
        speedometerContainer.style.visibility = 'visible';
        
        // Bir sonraki animasyon karesinde enter animasyonunu başlat
        requestAnimationFrame(() => {
          speedometerContainer.classList.add('speedometer-enter');
        });
      }
    },
    
    hideSpeedometerAnimation() {
      const speedometerContainer = document.querySelector('.speedometer-container');
      if (speedometerContainer) {
        // Önce speedometer-enter sınıfını kaldır
        speedometerContainer.classList.remove('speedometer-enter');
        
        // Çıkış animasyonunu başlat
        speedometerContainer.classList.add('speedometer-exit');
        
        // Animasyon tamamlandıktan sonra görünürlüğü kapat ve durumu güncelle
        setTimeout(() => {
          this.showSpeedometer = false;
          this.isInVehicle = false;
          this.updateNewLocationPosition(false); // Lokasyon çubuğunu aşağı taşı
          this.updateLocationPosition(); // %100 güvenlik için doğrudan DOM güncelleme
          
          // Animasyon tamamlandıktan sonra gizle
          setTimeout(() => {
            if (!this.isInVehicle && !this.showSpeedometer) {
              speedometerContainer.style.visibility = 'hidden';
            }
          }, 100);
        }, 600); // Çıkış animasyonu süresi kadar bekle
      } else {
        // Speedometer bulunamazsa durumu hemen güncelle
        this.showSpeedometer = false;
        this.isInVehicle = false;
        this.updateNewLocationPosition(false); // Lokasyon çubuğunu aşağı taşı
        this.updateLocationPosition(); // %100 güvenlik için doğrudan DOM güncelleme
      }
    },
    
    // Sayfa yüklendiğinde loading animasyonu
    initSpeedometerLoading() {
      const speedometerContainer = document.querySelector('.speedometer-container');
      if (speedometerContainer) {
        // Loading animasyonunu kullanma, sadece standart durumda bırak
        speedometerContainer.classList.remove('speedometer-loading');
        
        // Başlangıçta speedometer-exit sınıfını ekle ve visibility'yi hidden yap
        if (!this.isInVehicle) {
          speedometerContainer.classList.add('speedometer-exit');
          speedometerContainer.classList.remove('speedometer-enter');
          speedometerContainer.style.visibility = 'hidden';
        } else {
          // Araçtaysa görünür yap
          speedometerContainer.style.visibility = 'visible';
          speedometerContainer.classList.add('speedometer-enter');
          speedometerContainer.classList.remove('speedometer-exit');
        }
      }
    },
    
    // Sayfa yükleme animasyonu
    initLoadingAnimations() {
      // Stat göstergeleri için animasyon sınıfı ekle
      const statIndicators = document.querySelectorAll('.stat-indicator');
      statIndicators.forEach((indicator, index) => {
        // Her stat göstergesine animasyon sınıfını ekle
        indicator.style.animationDelay = `${0.5 + (index * 0.1)}s`;
        indicator.style.animationName = 'stat-indicator-entry';
      });
      
      // Ana HUD container'a animasyon sınıfı ekle
      const hudContainer = document.querySelector('.cyberpunk-hud');
      if (hudContainer) {
        hudContainer.style.animationDelay = '0.2s';
        hudContainer.style.animationName = 'cyber-hud-entry';
      }
      
      // Sayfanın tamamen yüklendiğini işaretle
      setTimeout(() => {
        this.isAppLoaded = true;
        console.log('💫 App loaded and animations completed');
      }, 2000); // Tüm animasyonların tamamlanması için yeterli süre
    },
    
    // Vites hesaplama
    calculateGear(speed, gear) {
      if (speed === 0) return 'P';
      if (speed < 0) return 'R';
      if (gear) return gear;
      
      // Hıza göre vites hesapla
      if (speed < 20) return '1';
      if (speed < 45) return '2';
      if (speed < 75) return '3';
      if (speed < 110) return '4';
      if (speed < 160) return '5';
      return '6';
    },
    
    // Konum güncelleme metodu - Anime.js ile modern ve daha akıcı
    updateLocation(street, district, x, y, force) {
      const newStreet = street || this.currentLocation.street;
      const newDistrict = district || this.currentLocation.district;
      
      // Koordinat güncelleme
      if (x !== undefined) this.currentLocation.coordinates.x = x;
      if (y !== undefined) this.currentLocation.coordinates.y = y;
      
      // District her zaman sessizce güncellenir
      this.currentLocation.district = newDistrict;
      
      // Animasyon bayrağını baştan devre dışı bırak
      this.locationUpdating = false;
      
      // Sokağı hızlıca güncelle, hiçbir animasyon kullanmadan
      this.currentLocation.street = newStreet;
      
      // Lokasyon bileşenine erişim
      const locationBar = document.getElementById('new-location-bar');
      if (locationBar) {
        // Tüm animasyon sınıflarını temizle
        locationBar.className = 'new-location-bar';
        
        // Sokak ismini direkt güncelle
        const streetEl = locationBar.querySelector('.loc-street');
        if (streetEl) {
          streetEl.textContent = newStreet;
        }
        
        // District ismini direkt güncelle
        const districtEl = locationBar.querySelector('.loc-district');
        if (districtEl) {
          districtEl.textContent = newDistrict;
        }
        
        // Pozisyonu hemen güncelle
        this.updateLocationPosition();
      }
    },
    
    // Eskiden kullanılan, şimdi optimize edilmiş basit güncelleme
    animateLocationChange(newStreet, force) {
      // Animasyon bayrağını baştan devre dışı bırak
      this.locationUpdating = false;
      
      // Sokağı hızlıca güncelle
      this.currentLocation.street = newStreet;
      
      // Lokasyon bileşenine erişim
      const locationBar = document.getElementById('new-location-bar');
      if (!locationBar) return;
      
      // Tüm animasyon sınıflarını temizle
      locationBar.className = 'new-location-bar';
      
      // Sokak ismini direkt güncelle
      const streetEl = locationBar.querySelector('.loc-street');
      if (streetEl) {
        streetEl.textContent = newStreet;
      }
      
      // Pozisyonu hemen güncelle
      this.updateLocationPosition();
    },
    
    updateStat(statName, value) {
      if (this[statName] !== undefined) {
        this[statName] = value;
      }
    },
    updateSpeed(value) {
      this.prevSpeed = this.speed; // Mevcut hızı önceki hız olarak kaydet
      this.speedUpdateTime = Date.now(); // Zaman damgasını güncelle
      this.speed = Math.min(Math.max(0, value), this.maxSpeed);
    },
    updateFuel(value) {
      this.fuel = Math.min(Math.max(0, value), 100);
    },
    updateNos(value) {
      this.nos = Math.min(Math.max(0, value), 100);
    },
    activateNos() {
      if (this.nos > 10) {
        this.nosActive = true;
        // NOS aktifken hız artışı
        this.speed = Math.min(this.speed + 30, this.maxSpeed);
        
        // NOS tüketimi
        const nosInterval = setInterval(() => {
          this.nos -= 2;
          if (this.nos <= 0) {
            this.deactivateNos();
            clearInterval(nosInterval);
          }
        }, 200);
        
        // 3 saniye sonra otomatik deaktif
        setTimeout(() => {
          this.deactivateNos();
          clearInterval(nosInterval);
        }, 3000);
      }
    },
    deactivateNos() {
      this.nosActive = false;
    },
    
    // Silah ile ilgili metodlar
    updateWeaponAmmo(value) {
      if (this.hasWeapon && this.currentWeapon) {
        this.currentWeapon.ammo = Math.min(Math.max(0, value), this.currentWeapon.maxAmmo);
      }
    },
    
    reloadWeapon() {
      if (this.hasWeapon && this.currentWeapon) {
        // Yeniden doldurma animasyonu için
        this.isReloading = true;
        
        // Gerçek uygulamada burada mermi sayısına göre yükleme yapılabilir
        setTimeout(() => {
          this.currentWeapon.ammo = this.currentWeapon.maxAmmo;
          this.isReloading = false;
        }, 1000);
      }
    },
    
    fireWeapon() {
      if (this.hasWeapon && this.currentWeapon && this.currentWeapon.ammo > 0) {
        this.currentWeapon.ammo--;
        
        // Animasyon efektleri veya ses efektleri eklenebilir
      }
    },
    
    switchWeapon(weaponIndex) {
      if (this.weaponInventory[weaponIndex]) {
        this.currentWeapon = JSON.parse(JSON.stringify(this.weaponInventory[weaponIndex]));
      }
    },
    
    toggleWeapon() {
      this.hasWeapon = !this.hasWeapon;
    },
    
    // Gear Class Methods
    getGearClass() {
      switch(this.currentGear) {
        case 'P': return 'gear-park';
        case 'R': return 'gear-reverse';  
        case 'N': return 'gear-neutral';
        case 'D': return 'gear-drive';
        case '1': case '2': case '3': case '4': case '5': case '6':
          return 'gear-manual';
        default: return 'gear-unknown';
      }
    },
    
    getGearModeClass() {
      if (this.currentGear === 'P') return 'mode-park';
      if (this.currentGear === 'R') return 'mode-reverse';
      if (this.currentGear === 'N') return 'mode-neutral';
      if (this.currentGear === 'D') return 'mode-auto';
      if (['1','2','3','4','5','6'].includes(this.currentGear)) return 'mode-manual';
      return 'mode-unknown';
    },
    
    // Modern Gear Icon System
    getGearIcon() {
      switch(this.currentGear) {
        case 'P': return 'fas fa-parking'; // Park icon
        case 'R': return 'fas fa-undo-alt'; // Reverse icon
        case 'N': return 'fas fa-minus-circle'; // Neutral icon
        case 'D': return 'fas fa-play'; // Drive icon
        case '1': return 'fas fa-dice-one'; // Manual 1
        case '2': return 'fas fa-dice-two'; // Manual 2
        case '3': return 'fas fa-dice-three'; // Manual 3
        case '4': return 'fas fa-dice-four'; // Manual 4
        case '5': return 'fas fa-dice-five'; // Manual 5
        case '6': return 'fas fa-dice-six'; // Manual 6
        default: return 'fas fa-question-circle'; // Unknown
      }
    },
    
    getGearStateClass() {
      switch(this.currentGear) {
        case 'P': return 'gear-park';
        case 'R': return 'gear-reverse';
        case 'N': return 'gear-neutral';
        case 'D': return 'gear-drive';
        case '1': case '2': case '3': case '4': case '5': case '6':
          return 'gear-manual';
        default: return 'gear-unknown';
      }
    },
    
    // Gear label için modern görünüm
    getGearLabel() {
      return this.currentGear === 'P' ? 'GEAR' : this.currentGear;
    },
    
    // Gear display değeri
    getGearDisplay() {
      return this.currentGear;
    },
    
    // Vehicle Status Update Methods
    updateSeatbelt(status) {
      this.seatbeltOn = status;
    },
    
    updateCruiseControl(status) {
      this.cruiseOn = status;
    },
    
    updateDoorLocks(status) {
      this.doorsLocked = status;
    },
    
    updateGear(gear) {
      this.currentGear = gear;
    },
    
    // Silah hover animasyonları
    weaponHoverIn() {
      const weaponBar = this.$refs.weaponBar;
      if (weaponBar && this.hasWeapon) {
        // Sadece kenarlığın rengi ve gölgesi değişsin, pozisyon değişmesin
        anime({
          targets: weaponBar,
          borderColor: ['rgba(0, 229, 255, 0.6)', 'rgba(211, 0, 197, 0.8)'],
          boxShadow: [
            'rgba(0, 229, 255, 0.4) 0px 0px 0.75rem, rgba(0, 229, 255, 0.1) 0px 0px 0.5rem inset',
            'rgba(211, 0, 197, 0.6) 0px 0px 1.2rem, rgba(211, 0, 197, 0.2) 0px 0px 0.8rem inset'
          ],
          duration: 300,
          easing: 'easeOutQuart'
        });
        
        // İkon animasyonu
        const weaponIcon = weaponBar.querySelector('.weapon-icon');
        if (weaponIcon) {
          anime({
            targets: weaponIcon,
            color: ['#05d9e8', '#d300c5'],
            filter: [
              'drop-shadow(0 0 3px #05d9e8)',
              'drop-shadow(0 0 5px #d300c5)'
            ],
            duration: 400,
            easing: 'easeOutQuad'
          });
        }
      }
    },
    
    weaponHoverOut() {
      const weaponBar = this.$refs.weaponBar;
      if (weaponBar && this.hasWeapon) {
        // Sadece kenarlığın rengi ve gölgesi geri gelsin, pozisyon değişmesin
        anime({
          targets: weaponBar,
          borderColor: ['rgba(211, 0, 197, 0.8)', 'rgba(0, 229, 255, 0.6)'],
          boxShadow: [
            'rgba(211, 0, 197, 0.6) 0px 0px 1.2rem, rgba(211, 0, 197, 0.2) 0px 0px 0.8rem inset',
            'rgba(0, 229, 255, 0.4) 0px 0px 0.75rem, rgba(0, 229, 255, 0.1) 0px 0px 0.5rem inset'
          ],
          duration: 400,
          easing: 'easeOutQuart'
        });
        
        // İkon animasyonu geri
        const weaponIcon = weaponBar.querySelector('.weapon-icon');
        if (weaponIcon) {
          anime({
            targets: weaponIcon,
            color: ['#d300c5', '#05d9e8'],
            filter: [
              'drop-shadow(0 0 5px #d300c5)',
              'drop-shadow(0 0 3px #05d9e8)'
            ],
            duration: 300,
            easing: 'easeOutQuad'
          });
        }
      }
    },
    
    // Mermi değişimi animasyonu
    animateAmmoChange(oldAmmo, newAmmo) {
      const ammoText = this.$refs.weaponBar?.querySelector('.ammo-text');
      const ammoCircle = this.$refs.weaponBar?.querySelector('.ammo-circle');
      
      if (ammoText && newAmmo !== oldAmmo) {
        // Mermi sayısı değişim animasyonu - sadece renk ve yazı için, pozisyon değiştirmeden
        anime({
          targets: ammoText,
          color: newAmmo < oldAmmo ? ['#05d9e8', '#ff0055', '#05d9e8'] : ['#05d9e8', '#39ff14', '#05d9e8'],
          duration: 400,
          easing: 'easeOutQuad'
        });
      }
      
      if (ammoCircle) {
        // Çember animasyonu - sadece stroke değişikliği, pozisyon değiştirmeden
        anime({
          targets: ammoCircle,
          strokeWidth: [2.5, 3, 2.5],
          duration: 350,
          easing: 'easeOutQuad'
        });
      }
      
      // Düşük mermi uyarısı - SADECE BORDER RENGİNİ DEĞİŞTİR, POZİSYON DEĞİŞTİRME
      if (newAmmo < this.currentWeapon.maxAmmo * 0.25 && newAmmo > 0) {
        const weaponBar = this.$refs.weaponBar;
        anime({
          targets: weaponBar,
          borderColor: ['#00e5ff', '#ff0055', '#00e5ff'],
          boxShadow: [
            'rgba(0, 229, 255, 0.4) 0px 0px 0.75rem, rgba(0, 229, 255, 0.1) 0px 0px 0.5rem inset',
            'rgba(255, 0, 85, 0.6) 0px 0px 1rem, rgba(255, 0, 85, 0.2) 0px 0px 0.75rem inset',
            'rgba(0, 229, 255, 0.4) 0px 0px 0.75rem, rgba(0, 229, 255, 0.1) 0px 0px 0.5rem inset'
          ],
          duration: 600,
          loop: 1,
          direction: 'alternate',
          easing: 'easeInOutQuad'
        });
      }
    },
    
    // Silah yeniden yükleme animasyonu
    weaponReloadAnimation() {
      const weaponBar = this.$refs.weaponBar;
      const ammoIndicator = weaponBar?.querySelector('.ammo-indicator');
      
      if (ammoIndicator) {
        // Sadece SVG çemberinin içindekileri döndür, tüm silah barını hareket ettirme
        anime({
          targets: ammoIndicator,
          rotateZ: [0, 360],
          duration: 900,
          easing: 'easeInOutBack'
        });
        
        // Mermi çemberi animasyonu - sadece renk ve stroke değişimi
        const ammoCircle = weaponBar.querySelector('.ammo-circle');
        if (ammoCircle) {
          anime({
            targets: ammoCircle,
            stroke: ['#00e5ff', '#ff9100', '#ff0055', '#00e5ff'],
            strokeWidth: [2.5, 3, 2.5],
            duration: 900,
            easing: 'easeInOutQuad'
          });
        }
      }
    },
    
    // Yeni lokasyon çubuğunun konumunu güncelleyen metot
    updateNewLocationPosition(isInVehicle) {
      const newLocationBar = document.getElementById('new-location-bar');
      if (!newLocationBar) return;
      
      // Animasyon sınıflarını temizle
      newLocationBar.className = 'new-location-bar';
      
      // Sadece bottom değerini değiştir - anında geçiş
      newLocationBar.style.bottom = isInVehicle ? '19.5rem' : '6.5rem';
      newLocationBar.style.transition = 'bottom 0.15s ease-out';
    },
    
    // Lokasyonu güncelleyen yeni güvenli metot - %100 stabil
    updateLocationPosition() {
      // Araç modu algılama
      const vehicleMode = this.isInVehicle || this.showSpeedometer;
      const newLocationBar = document.getElementById('new-location-bar');
      
      if (newLocationBar) {
        // Animasyon sınıflarını temizle
        newLocationBar.className = 'new-location-bar';
        
        // Tüm stil değerlerini direkt ata
        newLocationBar.style.opacity = '1';
        newLocationBar.style.visibility = 'visible';
        newLocationBar.style.transition = 'bottom 0.15s ease-out';
        newLocationBar.style.transform = 'translateZ(0)';
        newLocationBar.style.bottom = vehicleMode ? '19.5rem' : '6.5rem';
      }
    },
    
    // Yeni metod: Connector çizgilerini animasyonlu olarak vurgulama - DENGELİ VERSİYON
    highlightConnectorLines(newSpeed, oldSpeed) {
      // Hız değişiminde çizgilerin görünür olduğunu garantile
      this.fixAllConnectorLines();
      
      // Animasyonları daha sınırlı tut - sadece büyük değişimlerde
      if (Math.abs(newSpeed - oldSpeed) > 15) {
        // Sadece birkaç çizgiyi vurgula
        const lines = document.querySelectorAll('.connector-line');
        
        // Önce tüm çizgilerin görünür olduğunu garantile
        lines.forEach(line => {
          line.style.opacity = '1';
          line.style.visibility = 'visible';
          line.style.strokeOpacity = '1';
          line.style.display = 'block';
        });
        
        // Daha az sayıda çizgi vurgula
        const linesToHighlight = Math.min(3, Math.floor(Math.abs(newSpeed - oldSpeed) / 20));
        
        // Sadece büyük hız değişimlerinde vurgula ve daha sakin animasyonlar kullan
        if (linesToHighlight > 0) {
          for (let i = 0; i < linesToHighlight; i++) {
            const randomIndex = Math.floor(Math.random() * lines.length);
            const line = lines[randomIndex];
            
            // Sadece çizginin opaklığını ve kalınlığını değiştir, renk değişimi yok
            const originalWidth = parseFloat(line.getAttribute('stroke-width') || '1');
            const maxWidth = originalWidth * 1.5; // Daha az kalınlık artışı
            
            // Daha sakin ve kısa animasyon
            anime({
              targets: line,
              opacity: [0.8, 1, 0.8],
              strokeWidth: [originalWidth, maxWidth, originalWidth],
              duration: 400, // Daha kısa süre
              easing: 'easeOutCubic',
              complete: () => {
                // Animasyon bitiminde çizgilerin görünürlüğünü garantile
                line.style.opacity = '1';
                line.style.visibility = 'visible';
                line.style.strokeOpacity = '1';
                line.style.display = 'block';
                line.style.strokeWidth = originalWidth;
              }
            });
          }
        }
      }
      
      // Her durumda çizgilerin görünürlüğünü garantile
      setTimeout(() => {
        this.fixAllConnectorLines();
        this.fixAllSVGLines();
      }, 500);
    },
    ensureLinesVisibility() {
      // Tüm çizgilerin CSS özelliklerini !important ile güçlendir
      const lines = document.querySelectorAll('.connector-line, .kmh-line');
      lines.forEach(line => {
        line.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; display: block !important;";
      });
      
      // Kapsayıcı elemanların da görünürlüğünü garantile
      const containers = document.querySelectorAll('.connector-lines, .kmh-decorations');
      containers.forEach(container => {
        container.style.cssText = "opacity: 1 !important; visibility: visible !important; display: block !important;";
      });
      
      // SVG elemanların da görünür olduğunu garantile
      const svgElements = document.querySelectorAll('.speedometer-container svg, .speedometer-container svg *');
      svgElements.forEach(el => {
        if (el.classList.contains('connector-line') || el.classList.contains('kmh-line')) {
          el.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important;";
        }
      });
    },
    applyHighSpeedEffects() {
      const container = document.querySelector('.speedometer-container');
      if (container) {
        container.classList.add('high-speed-mode');
        
        // Tüm bağlantı çizgilerinin görünür olduğunu garantile
        const lines = container.querySelectorAll('.connector-line');
        lines.forEach(line => {
          line.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; display: block !important;";
          
          // SVG path içinde görünürlüğü garantile
          const paths = line.querySelectorAll('path');
          if (paths.length > 0) {
            paths.forEach(path => {
              path.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important;";
            });
          }
        });
        
        // KM/H çizgilerini de görünür yap
        const kmhLines = container.querySelectorAll('.kmh-line');
        if (kmhLines.length > 0) {
          kmhLines.forEach(line => {
            line.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; display: block !important;";
          });
        }
        
        // KM/H dekorasyonlarını görünür yap
        const kmhDecorations = document.querySelector('.kmh-decorations');
        if (kmhDecorations) {
          kmhDecorations.style.cssText = "opacity: 1 !important; visibility: visible !important; display: block !important;";
        }
        
        // Bağlantı çizgileri kapsayıcısını görünür yap
        const connectorLinesContainer = document.querySelector('.connector-lines');
        if (connectorLinesContainer) {
          connectorLinesContainer.style.cssText = "opacity: 1 !important; visibility: visible !important; display: block !important;";
        }
        
        // Animasyon efekti - görünürlüğü bozmayan versiyonu
        anime({
          targets: '.center-speed-value',
          scale: [1, 1.1, 1],
          color: ['#05d9e8', '#ff2a6d'],
          duration: 600,
          easing: 'easeOutExpo',
          complete: () => {
            // Animasyon bittiğinde tekrar görünürlüğü kontrol et
            this.ensureLinesVisibility();
          }
        });
        
        // 100ms sonra tekrar kontrol et (animasyon başladıktan hemen sonra)
        setTimeout(() => {
          this.ensureLinesVisibility();
        }, 100);
        
        // 300ms sonra tekrar kontrol et (animasyon sırasında)
        setTimeout(() => {
          this.ensureLinesVisibility();
        }, 300);
        
        // 700ms sonra son bir kez kontrol et (animasyon bitiminden sonra)
        setTimeout(() => {
          this.ensureLinesVisibility();
        }, 700);
      }
    },
    // Tamamen yeni bir fonksiyon ekleyelim - connector çizgilerini zorla görünür kılan ve animasyonlarda bile çalışan
    forceConnectorLinesVisibility() {
      // Connector lines içindeki tüm çizgileri bul
      const container = document.querySelector('.connector-lines');
      if (!container) return;
      
      // Kapsayıcının kesinlikle görünür olduğunu garanti et
      container.style.cssText = "opacity: 1 !important; visibility: visible !important; display: block !important; pointer-events: auto !important; z-index: 100 !important;";
      
      // İçindeki tüm çizgileri bul
      const lines = container.querySelectorAll('.connector-line');
      if (!lines || lines.length === 0) return;
      
      // Her bir çizginin kesinlikle görünür olduğunu garanti et
      lines.forEach(line => {
        // En güçlü CSS özellikleri
        line.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important; display: block !important; pointer-events: auto !important;";
        
        // SVG stroke özelliklerini de doğrudan ayarla
        line.setAttribute('stroke-opacity', '1');
        line.setAttribute('visibility', 'visible');
        
        // Çizginin tipine göre kalınlığı garanti et
        if (line.classList.contains('major-line')) {
          line.style.setProperty('stroke-width', '0.8', 'important');
          line.setAttribute('stroke-width', '0.8');
        } else if (line.classList.contains('medium-line')) {
          line.style.setProperty('stroke-width', '0.6', 'important');
          line.setAttribute('stroke-width', '0.6');
        } else {
          line.style.setProperty('stroke-width', '0.4', 'important');
          line.setAttribute('stroke-width', '0.4');
        }
        
        // İç elemanları da garanti et
        const paths = line.querySelectorAll('path');
        if (paths && paths.length > 0) {
          paths.forEach(path => {
            path.style.cssText = "opacity: 1 !important; visibility: visible !important; stroke-opacity: 1 !important;";
            path.setAttribute('stroke-opacity', '1');
            path.setAttribute('visibility', 'visible');
          });
        }
      });
    },
    ensureKmhStatic() {
      // KM/H elemanlarını seç
      const speedometerUnit = document.querySelector('.speedometer-unit');
      
      // Tüm animasyon ve transition özelliklerini kaldır
      if (speedometerUnit) {
        speedometerUnit.style.animation = 'none';
        speedometerUnit.style.transition = 'none';
        speedometerUnit.classList.remove('kmh-highlight', 'speed-change-effect');
      }
    }
  },

  watch: {
    // Mermi değişimini takip et
    'currentWeapon.ammo': function(newVal, oldVal) {
      if (this.hasWeapon && oldVal !== undefined && newVal !== oldVal) {
        this.animateAmmoChange(oldVal, newVal);
      }
    },
    
    // Yeniden yükleme durumunu takip et
    'isReloading': function(newVal) {
      if (newVal) {
        this.weaponReloadAnimation();
      }
    },
    
    // Araç durumu değişimini izle - kritik
    'isInVehicle': function(newVal) {
      this.updateLocationPosition();
    },
    
    // Speedometer durumu değişimini izle - kritik
    'showSpeedometer': function(newVal) {
      this.updateLocationPosition();
    },
    
    // RPM değişimini izle ve connector çizgilerini animasyonlu vurgula
    'rpm': function(newVal, oldVal) {
      // RPM değişim zamanını kaydet ve değişim oranını hesapla
      const now = Date.now();
      const timeDiff = now - this.lastRpmUpdateTime;
      this.rpmChangeRate = timeDiff > 0 ? (newVal - oldVal) / timeDiff * 1000 : 0;
      this.lastRpmUpdateTime = now;
      
      // Hızlanma/yavaşlama durumunu güncelle - daha güçlü bir eşik değeri ile
      if (Math.abs(this.rpmChangeRate) > 300) {
        this.isAccelerating = this.rpmChangeRate > 0;
        this.isDecelerating = this.rpmChangeRate < 0;
      } else {
        this.isAccelerating = false;
        this.isDecelerating = false;
      }
      
      // RPM değişiminde çizgilerin görünürlüğünü garantile
      this.fixAllConnectorLines();
      
      // Sadece büyük RPM değişimlerinde animasyon yap
      if (Math.abs(newVal - oldVal) > 800) {
        const container = document.querySelector('.speedometer-container');
        if (container) {
          // RPM artıyor mu azalıyor mu?
          const isIncreasing = newVal > oldVal;
          
          // Vurgulanan çizgi sayısı - daha sınırlı tut
          const linesToHighlight = Math.min(2, Math.floor(Math.abs(newVal - oldVal) / 1000));
          
          // Sadece büyük değişimlerde vurgula
          if (linesToHighlight > 0) {
            const lines = container.querySelectorAll('.connector-line');
            
            // Tüm çizgilerin görünür olduğunu garantile
            lines.forEach(line => {
              line.style.opacity = '1';
              line.style.visibility = 'visible';
              line.style.strokeOpacity = '1';
              line.style.display = 'block';
            });
            
            // Sadece birkaç çizgiyi rastgele vurgula
            for (let i = 0; i < linesToHighlight; i++) {
              const randomIndex = Math.floor(Math.random() * lines.length);
              const line = lines[randomIndex];
              
              // Çizginin tipine göre kalınlığı belirle
              const baseWidth = line.classList.contains('major-line') ? 0.8 : 
                                  line.classList.contains('medium-line') ? 0.6 : 0.4;
              
              // Daha dengeli ve sakin animasyon
              anime({
                targets: line,
                opacity: [0.8, 1, 0.8],
                strokeWidth: [
                  baseWidth,
                  baseWidth * 1.5,
                  baseWidth
                ],
                duration: 300, // Daha kısa süre
                easing: 'easeOutQuad',
                complete: () => {
                  // Animasyon bittiğinde sabit değerlere geri dön
                  line.style.opacity = '1';
                  line.style.visibility = 'visible';
                  line.style.strokeOpacity = '1';
                  line.style.display = 'block';
                  line.style.strokeWidth = baseWidth;
                }
              });
            }
          }
          
          // RPM 85% üzerinde ise ekstra titreşim efekti - sadece boşta veya parkta
          if (newVal > this.maxRpm * 0.85 && (this.currentGear === 'P' || this.currentGear === 'N')) {
            // Mikro titreşim animasyonu - daha hafif ve kontrollü
            anime({
              targets: '.speedometer-container',
              translateX: [0, -0.5, 0.5, 0],
              translateY: [0, 0.5, -0.5, 0],
              duration: 200,
              easing: 'easeInOutSine'
            });
          }
        }
      }
      
      // Animasyon sonrası çizgilerin görünürlüğünü garantile
      setTimeout(() => {
        this.fixAllConnectorLines();
      }, 350);
    },
    
    // Hız değişimini izle - yeni iğne için
    'speed': function(newVal, oldVal) {
      // Hız değişim zamanını kaydet ve değişim oranını hesapla
      const now = Date.now();
      const timeDiff = now - this.lastSpeedUpdateTime;
      this.speedChangeRate = timeDiff > 0 ? (newVal - oldVal) / timeDiff * 1000 : 0;
      this.lastSpeedUpdateTime = now;
      
      // Hızlanma/yavaşlama durumunu güncelle (hız değişimine göre de)
      if (Math.abs(this.speedChangeRate) > 5) {
        this.isAccelerating = this.speedChangeRate > 0;
        this.isDecelerating = this.speedChangeRate < 0;
      }
      
      // Önceki hızı kaydet - sadece küçülürse hemen güncelle, 
      // büyürse aşamalı geçiş için bir süre bekle
      if (newVal < oldVal) {
        this.prevSpeed = oldVal; // Yavaşlamada hemen güncelle
      } else {
        // Hızlanmada gecikme ile güncelle
        setTimeout(() => {
          if (this.prevSpeed < newVal) {
            this.prevSpeed = newVal;
          }
        }, 300); // Hafif gecikme ile güncelle
      }
      
      // Önce tüm çizgileri sabitle
      this.fixAllConnectorLines();
      
      // Sınıfları güncelle
      this.updateSpeedometerClasses();
      
      // Her hız değişiminde çizgilerin görünürlüğünü garanti et
      setTimeout(() => {
        this.fixAllSVGLines();
        this.ensureLinesVisibility();
      }, 100);
    }
  },

  created() {
    window.addEventListener('message', this.handleEventMessage);
    
    // Başlangıçta UI'ı gizli tut (false)
    this.ui = false;
    
    // Başlangıçta lokasyon çubuğunu göster
    setTimeout(() => {
      this.updateLocationPosition();
    }, 500);
    
    // Sayfa yüklenir yüklenmez tüm çizgilerin görünürlüğünü garantile
    setTimeout(() => {
      this.fixAllConnectorLines();
      this.fixAllSVGLines();
    }, 100);
    
    // Lokasyon pozisyonunu düzenli olarak kontrol eden interval
    this.locationCheckInterval = setInterval(() => {
      // Lokasyon güncelleme bayrağını devre dışı bırak
      this.locationUpdating = false;
      
      // Lokasyon pozisyonunu güncelle
      this.updateLocationPosition();
      
      // Animasyon sınıflarını temizle
      const newLocationBar = document.getElementById('new-location-bar');
      if (newLocationBar) {
        newLocationBar.className = 'new-location-bar';
        if (this.isInVehicle || this.showSpeedometer) {
          newLocationBar.classList.add('location-vehicle-mode');
        } else {
          newLocationBar.classList.add('location-normal-mode');
        }
      }
    }, 200); // Her 200ms'de bir kontrol et
    
    // Hız göstergesindeki çizgilerin görünürlüğünü kontrol et
    this.lineVisibilityInterval = setInterval(() => {
      if (this.isInVehicle || this.showSpeedometer) {
        this.fixAllConnectorLines();
      }
    }, 200);
  },

  mounted() {
    this.$nextTick(() => {
      this.initSpeedometerLoading(); // Speedometer yükleme işlemini başlat
      this.initLoadingAnimations(); // Yükleme animasyonlarını başlat
      
      // İlk yüklenmede lokasyon pozisyonunu ayarla
      this.updateLocationPosition();
      
      // locationUpdating bayrağını false yap - animasyon göstermesin
      this.locationUpdating = false;
      
      // KM/H animasyonlarını kaldır - sabit görünüm için
      this.ensureKmhStatic();
      
      // 500ms sonra tekrar kontrol et - daha kısa süre
      setTimeout(() => {
        this.locationUpdating = false;
        this.updateLocationPosition();
        this.ensureKmhStatic();
      }, 500);
      
      // Ekstra güvenlik kontrolü - 1 saniye sonra
      setTimeout(() => {
        // Lokasyon pozisyonunu son bir kez güncelle
        this.updateLocationPosition();
        
        // Bütün animasyon sınıflarını temizle
        const newLocationBar = document.getElementById('new-location-bar');
        if (newLocationBar) {
          newLocationBar.className = 'new-location-bar';
          if (this.isInVehicle || this.showSpeedometer) {
            newLocationBar.classList.add('location-vehicle-mode');
          } else {
            newLocationBar.classList.add('location-normal-mode');
          }
        }
      }, 1000);
    });
  },
    
  computed: {
    locationBarPosition() {
       // Direkt hesaplanan pozisyon değerleri - hiçbir gecikme olmadan
       const vehicleMode = this.isInVehicle || this.showSpeedometer;
       
       return {
         position: 'fixed',
         zIndex: 9999,
         visibility: 'visible', 
         opacity: 1,
         bottom: vehicleMode ? '19.5rem' : '6.5rem',
         left: '1.875rem',
         transform: 'translateZ(0)', // Hardware acceleration
         willChange: 'transform, bottom', // Browser optimizasyonu
         transition: 'bottom 0.15s ease-out' // Transition süresini kısalttık ve basitleştirdik
       };
     },
     
     dynamicClasses() {
       // Sabit ve güvenilir sınıf hesaplaması - %100 stabil geçişler için
       const vehicleMode = this.isInVehicle || this.showSpeedometer;
       
       // Temel sınıf - her zaman doğru değeri gösterir
       let additionalClass = vehicleMode ? 'location-vehicle-mode' : 'location-normal-mode';
       
       // Doğrudan DOM manipülasyonu için güvenli metot - Daha temiz versiyonu
       this.$nextTick(() => {
         const newLocationBar = document.getElementById('new-location-bar');
         if (newLocationBar) {
           // Doğrudan stil atamaları - hiçbir zaman başarısız olmaz
           newLocationBar.style.left = '1.875rem';
           newLocationBar.style.transform = 'translateZ(0)';
           newLocationBar.style.willChange = 'transform, bottom';
           newLocationBar.style.transition = 'bottom 0.15s ease-out'; // Transition süresini kısalttık
           newLocationBar.style.opacity = '1';
           newLocationBar.style.visibility = 'visible';
           
           // Araç durumuna göre kesin pozisyon - %100 doğru değerler
           newLocationBar.style.bottom = vehicleMode ? '19.5rem' : '6.5rem';
           
           // Animasyon sınıflarını kaldır - kendiliğinden animasyona girmesin
           if (!this.locationUpdating) {
             newLocationBar.classList.remove('loc-updating');
             newLocationBar.classList.remove('location-updating');
             newLocationBar.classList.remove('location-highlight');
             newLocationBar.classList.remove('location-magical');
           }
         }
       });
       
       // SADECE updateLocation ve animateLocationChange tarafından true yapıldığında
       // animasyon sınıfını ekle
       if (this.locationUpdating) {
         additionalClass += ' location-updating';
       }
       
       return {
         class: additionalClass,
         style: {
           left: "1.875rem",
           bottom: vehicleMode ? "19.5rem" : "6.5rem",
           transform: "translateZ(0)",
           willChange: "transform, bottom",
           opacity: "1",
           visibility: "visible"
         }
       };
     },
     
     // Silah bar sınıfları
     weaponBarClasses() {
       let classes = '';
       
       if (this.hasWeapon) {
         classes += ' weapon-visible';
       }
       
       if (this.isWeaponLoading) {
         classes += ' weapon-loading';
       }
       
       if (this.isReloading) {
         classes += ' weapon-reloading';
       }
       
       return classes;
     },

    circumference() {
      return 2 * Math.PI * 40;
    },
    healthOffset() {
      return this.circumference - (this.health / 100) * this.circumference;
    },
    armorOffset() {
      return this.circumference - (this.armor / 100) * this.circumference;
    },
    hungerOffset() {
      return this.circumference - (this.hunger / 100) * this.circumference;
    },
    thirstOffset() {
      return this.circumference - (this.thirst / 100) * this.circumference;
    },
    stressOffset() {
      return this.circumference - (this.stress / 100) * this.circumference;
    },
    formattedCash() {
      return new Intl.NumberFormat('tr-TR').format(this.cash);
    },
    formattedBlackMoney() {
      return new Intl.NumberFormat('tr-TR').format(this.blackMoney);
    },
    formattedBankMoney() {
      return new Intl.NumberFormat('tr-TR').format(this.bankMoney);
    },
    speedCircumference() {
      return 2 * Math.PI * 42; // 2πr (r=42)
    },
    speedOffset() {
      // Çemberin tam dolu görünmesi için hesaplama güncellendi
      // 0 değeri çemberin tam dolu olduğu durumu ifade eder
      // Speed maksimum değere ulaştığında çember tamamen dolmuş olacak
      return this.speedCircumference * (1 - (this.speed / this.maxSpeed));
    },
    fuelPercentage() {
      return this.fuel; // 0-100 arası değer
    },
    nosPercentage() {
      return this.nos; // 0-100 arası değer
    },
    fuelCircumference() {
      return 2 * Math.PI * 34; // 2πr (r=34)
    },
    fuelOffset() {
      // Çemberin tam dolu görünmesi için hesaplama güncellendi
      // 0 değeri çemberin tam dolu olduğu durumu ifade eder
      // Fuel 100% olduğunda çember tamamen dolmuş olacak
      return this.fuelCircumference * (1 - (this.fuel / 100));
    },
    nosCircumference() {
      return 2 * Math.PI * 26; // 2πr (r=26)
    },
    nosOffset() {
      // Çemberin tam dolu görünmesi için hesaplama güncellendi
      // 0 değeri çemberin tam dolu olduğu durumu ifade eder
      // NOS 100% olduğunda çember tamamen dolmuş olacak
      return this.nosCircumference * (1 - (this.nos / 100));
    },
    rpmCircumference() {
      return 2 * Math.PI * 18; // 2πr (r=18)
    },
    rpmOffset() {
      // Çemberin tam dolu görünmesi için hesaplama güncellendi
      // 0 değeri çemberin tam dolu olduğu durumu ifade eder
      // RPM maksimum değere ulaştığında çember tamamen dolmuş olacak
      return this.rpmCircumference * (1 - (this.rpm / this.maxRpm));
    },
    isHighTemp() {
      return this.engineTemp > 100; // 100 derece üzeri yüksek sıcaklık
    },
    ammoCircumference() {
      return 2 * Math.PI * 15; // 2πr (r=15 - SVG çemberi için)
    },
    ammoOffset() {
      const percent = this.currentWeapon.ammo / Math.max(1, this.currentWeapon.maxAmmo);
      return this.ammoCircumference * (1 - percent);
    }
  },
  beforeDestroy() {
    // Interval'i temizle
    if (this.lineVisibilityInterval) {
      clearInterval(this.lineVisibilityInterval);
    }
    
    // Lokasyon kontrol interval'ini temizle
    if (this.locationCheckInterval) {
      clearInterval(this.locationCheckInterval);
    }
  }
})
  















