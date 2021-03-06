<?php
/**
 *
 * Copyright (C) Villanova University 2007.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

require_once ROOT_DIR . '/services/MyResearch/MyResearch.php';
require_once ROOT_DIR . '/sys/eContent/EContentRecord.php';

class OverdriveHolds extends MyResearch {
	function launch(){
		global $configArray;
		global $interface;
		global $user;
		global $timer;

		require_once ROOT_DIR . '/Drivers/OverDriveDriverFactory.php';
		$overDriveDriver = OverDriveDriverFactory::getDriver();
		$overDriveHolds = $overDriveDriver->getOverDriveHolds($user);
		//Load the full record for each item in the wishlist
		foreach ($overDriveHolds['holds'] as $sectionKey => $sectionData){
			foreach ($sectionData as $key => $item){
				if ($item['recordId'] != -1){
					$econtentRecord = new EContentRecord();
					$econtentRecord->id = $item['recordId'];
					$econtentRecord->find(true);
					$item['record'] = clone($econtentRecord);
				} else{
					$item['record'] = null;
				}
				if ($sectionKey == 'available'){
					if (isset($item['formats'])){
						$item['numRows'] = count($item['formats']) + 1;
					}
				}
				$overDriveHolds['holds'][$sectionKey][$key] = $item;
			}
		}
		$interface->assign('overDriveHolds', $overDriveHolds['holds']);

		$interface->assign('ButtonBack',true);
		$interface->assign('ButtonHome',true);
		$interface->assign('MobileTitle','OverDrive Holds');

		$hasSeparateTemplates = $interface->template_exists('MyResearch/overDriveAvailableHolds.tpl');
		if ($hasSeparateTemplates){
			$section = isset($_REQUEST['section']) ? $_REQUEST['section'] : 'available';
			if ($section == 'available'){
				$interface->setPageTitle('Available Holds from OverDrive');
				if (!isset($configArray['OverDrive']['interfaceVersion']) || $configArray['OverDrive']['interfaceVersion'] == 1){
					$interface->setTemplate('overDriveAvailableHolds.tpl');
				}else{
					$interface->setTemplate('overDriveAvailableHolds2.tpl');
				}
			}else{
				$interface->setPageTitle('On Hold in OverDrive');
				$interface->setTemplate('overDriveUnavailableHolds.tpl');
			}
		}else{
			$interface->setTemplate('overDriveHolds.tpl');
			$interface->setPageTitle('OverDrive Holds');
		}
		$interface->display('layout.tpl');
	}

}