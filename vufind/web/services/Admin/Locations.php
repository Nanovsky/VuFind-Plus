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

require_once ROOT_DIR . '/Action.php';
require_once ROOT_DIR . '/services/Admin/ObjectEditor.php';
require_once 'XML/Unserializer.php';

class Locations extends ObjectEditor
{

	function getObjectType(){
		return 'Location';
	}
	function getToolName(){
		return 'Locations';
	}
	function getPageTitle(){
		return 'Locations (Branches)';
	}
	function getAllObjects(){
		//Look lookup information for display in the user interface
		global $user;

		$location = new Location();
		$location->orderBy('displayName');
		if (!$user->hasRole('opacAdmin')){
			//Scope to just locations for the user based on home library
			$patronLibrary = Library::getLibraryForLocation($user->homeLocationId);
			$location->libraryId = $patronLibrary->libraryId;
		}
		$location->find();
		$locationList = array();
		while ($location->fetch()){
			$locationList[$location->locationId] = clone $location;
		}
		return $locationList;
	}

	function getObjectStructure(){
		return Location::getObjectStructure();
	}

	function getPrimaryKeyColumn(){
		return 'code';
	}

	function getIdKeyColumn(){
		return 'locationId';
	}
	function getAllowableRoles(){
		return array('opacAdmin', 'libraryAdmin');
	}
	function showExportAndCompare(){
		global $user;
		return $user->hasRole('opacAdmin');
	}
	function canAddNew(){
		global $user;
		return $user->hasRole('opacAdmin');
	}
	function canDelete(){
		global $user;
		return $user->hasRole('opacAdmin');
	}
	function getAdditionalObjectActions($existingObject){
		$objectActions = array();
		if ($existingObject != null){
			$objectActions[] = array(
				'text' => 'Edit Facets',
				'url' => '/Admin/LocationFacetSettings?locationId=' . $existingObject->locationId,
			);
			$objectActions[] = array(
				'text' => 'Reset Facets To Default',
				'url' => '/Admin/Locations?objectAction=resetFacetsToDefault&amp;id=' . $existingObject->locationId,
			);
			$objectActions[] = array(
				'text' => 'Copy Location Facets',
				'url' => '/Admin/Locations?id=' . $existingObject->locationId . '&amp;objectAction=copyFacetsFromLocation',
			);
		}else{
			echo("Existing object is null");
		}
		return $objectActions;
	}

	function copyFacetsFromLocation(){
		$locationId = $_REQUEST['id'];
		if (isset($_REQUEST['submit'])){
			$location = new Location();
			$location->locationId = $locationId;
			$location->find(true);
			$location->clearFacets();

			$locationToCopyFromId = $_REQUEST['locationToCopyFrom'];
			$locationToCopyFrom = new Location();
			$locationToCopyFrom->locationId = $locationToCopyFromId;
			$location->find(true);

			$facetsToCopy = $locationToCopyFrom->facets;
			foreach ($facetsToCopy as $facetKey => $facet){
				$facet->locationId = $locationId;
				$facet->id = null;
				$facetsToCopy[$facetKey] = $facet;
			}
			$location->facets = $facetsToCopy;
			$location->update();
			header("Location: /Admin/Locations?objectAction=edit&id=" . $locationId);
		}else{
			//Prompt user for the location to copy from
			$allLocations = $this->getAllObjects();

			unset($allLocations[$locationId]);
			foreach ($allLocations as $key => $location){
				if (count($location->facets) == 0){
					unset($allLocations[$key]);
				}
			}
			global $interface;
			$interface->assign('allLocations', $allLocations);
			$interface->assign('id', $locationId);
			$interface->setTemplate('../Admin/copyLocationFacets.tpl');
		}
	}

	function resetFacetsToDefault(){
		$location = new Location();
		$locationId = $_REQUEST['id'];
		$location->locationId = $locationId;
		if ($location->find(true)){
			$location->clearFacets();

			$defaultFacets = Location::getDefaultFacets($locationId);

			$location->facets = $defaultFacets;
			$location->update();

			$_REQUEST['objectAction'] = 'edit';
		}
		$structure = $this->getObjectStructure();
		header("Location: /Admin/Locations?objectAction=edit&id=" . $libraryId);
	}
}