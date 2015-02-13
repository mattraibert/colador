class PopulateLocations < ActiveRecord::Migration
  def up
    locations = [
      {abbr: 'afr1', top: 670, left: 1020},
      {abbr: 'ant1', top: 200, left: 400},
      {abbr: 'arg1', top: 600, left: 535},
      {abbr: 'arg12', top: 600, left: 525},
      {abbr: 'arg13', top: 600, left: 515},
      {abbr: 'arg14', top: 600, left: 505},
      {abbr: 'arg2', top: 650, left: 500},
      {abbr: 'arg22', top: 640, left: 490},
      {abbr: 'arg3', top: 550, left: 500},
      {abbr: 'arg4', top: 740, left: 600},
      {abbr: 'bar1', top: 185, left: 460},
      {abbr: 'bel1', top: 180, left: 240},
      {abbr: 'bol1', top: 450, left: 450},
      {abbr: 'bol2', top: 470, left: 450},
      {abbr: 'bra1', top: 450, left: 620},
      {abbr: 'bra2', top: 480, left: 620},
      {abbr: 'bra3', top: 500, left: 600},
      {abbr: 'bra4', top: 540, left: 580},
      {abbr: 'bra5', top: 310, left: 550},
      {abbr: 'bra6', top: 370, left: 430},
      {abbr: 'bra7', top: 320, left: 440},
      {abbr: 'bra8', top: 400, left: 500},
      {abbr: 'bra9', top: 350, left: 600},
      {abbr: 'chi1', top: 600, left: 440},
      {abbr: 'chi2', top: 490, left: 420},
      {abbr: 'chi3', top: 550, left: 435},
      {abbr: 'chi4', top: 700, left: 475},
      {abbr: 'chi5', top: 725, left: 475},
      {abbr: 'chi6', top: 780, left: 530},
      {abbr: 'col1', top: 250, left: 350},
      {abbr: 'cos1', top: 235, left: 270},
      {abbr: 'cub1', top: 125, left: 280},
      {abbr: 'cub2', top: 125, left: 290},
      {abbr: 'cub3', top: 125, left: 300},
      {abbr: 'cub4', top: 135, left: 310},
      {abbr: 'cub5', top: 130, left: 320},
      {abbr: 'cur1', top: 200, left: 380},
      {abbr: 'domrep1', top: 140, left: 370},
      {abbr: 'ecu1', top: 335, left: 325},
      {abbr: 'els1', top: 205, left: 225},
      {abbr: 'els11', top: 215, left: 215},
      {abbr: 'eur1', top: 640, left: 1020},
      {abbr: 'gre1', top: 205, left: 460},
      {abbr: 'gua1', top: 200, left: 205},
      {abbr: 'gua2', top: 190, left: 220},
      {abbr: 'guy1', top: 250, left: 460},
      {abbr: 'hai1', top: 150, left: 355},
      {abbr: 'hon1', top: 195, left: 235},
      {abbr: 'hon2', top: 195, left: 245},
      {abbr: 'jam1', top: 160, left: 325},
      {abbr: 'jam2', top: 160, left: 310},
      {abbr: 'jam3', top: 175, left: 310},
      {abbr: 'mex1', top: 170, left: 160},
      {abbr: 'mex2', top: 175, left: 185},
      {abbr: 'mex22', top: 185, left: 195},
      {abbr: 'mex23', top: 175, left: 195},
      {abbr: 'nic1', top: 215, left: 250},
      {abbr: 'nic2', top: 200, left: 270},
      {abbr: 'pan1', top: 240, left: 310},
      {abbr: 'par1', top: 510, left: 515},
      {abbr: 'par2', top: 500, left: 495},
      {abbr: 'par3', top: 490, left: 490},
      {abbr: 'par4', top: 520, left: 5305},
      {abbr: 'par5', top: 500, left: 505},
      {abbr: 'per1', top: 400, left: 350},
      {abbr: 'per2', top: 400, left: 370},
      {abbr: 'pue1', top: 150, left: 400},
      {abbr: 'sea1', top: 200, left: 600},
      {abbr: 'stj1', top: 145, left: 420},
      {abbr: 'stk1', top: 150, left: 440},
      {abbr: 'sur1', top: 260, left: 490},
      {abbr: 'tat1', top: 210, left: 450},
      {abbr: 'uru1', top: 580, left: 560},
      {abbr: 'usa1', top: 645, left: 965},
      {abbr: 'ven1', top: 240, left: 433},
      {abbr: 'inels1', top: 640, left: 80},
      {abbr: 'inels2', top: 620, left: 90},
      {abbr: 'inels3', top: 635, left: 105},
      {abbr: 'inels4', top: 640, left: 80},
      {abbr: 'inels5', top: 650, left: 100},
      {abbr: 'inels6', top: 635, left: 100},
      {abbr: 'inels7', top: 640, left: 100},
      {abbr: 'inhon1', top: 610, left: 125},
      {abbr: 'bar2', top: 185, left: 475},
      {abbr: 'incos1', top: 750, left: 200},
      {abbr: 'incos2', top: 750, left: 215},
      {abbr: 'domrep2', top: 125, left: 385},
      {abbr: 'inels6', top: 635, left: 100},
      {abbr: 'ingua1', top: 590, left: 75, },
      {abbr: 'ingua2', top: 550, left: 75, },
      {abbr: 'ingua3', top: 570, left: 75, },
      {abbr: 'ingua4', top: 590, left: 55, },
      {abbr: 'inhon1', top: 590, left: 155, },
      {abbr: 'inhon2', top: 610, left: 155, },
      {abbr: 'mex3', top: 100, left: 150},
      {abbr: 'mex4', top: 120, left: 110},
      {abbr: 'mie1', top: 650, left: 1045, },
      {abbr: 'innic1', top: 690, left: 200, },
      {abbr: 'innic2', top: 650, left: 200, },
      {abbr: 'innic3', top: 670, left: 200, },
      {abbr: 'innic4', top: 690, left: 180, },
      {abbr: 'innic5', top: 670, left: 180, },
      {abbr: 'inpan1', top: 775, left: 280, },
      {abbr: 'inpan2', top: 775, left: 300, },
      {abbr: 'sea2', top: 621, left: 417},
      {abbr: 'usa2', top: 660, left: 965},
      {abbr: 'usa3', top: 675, left: 965},
      {abbr: 'usa4', top: 645, left: 950},
      {abbr: 'usa5', top: 645, left: 965},
    ]
    locations.each { |l| Location.create!(l) }
  end

  def down
    Location.delete_all
  end
end
