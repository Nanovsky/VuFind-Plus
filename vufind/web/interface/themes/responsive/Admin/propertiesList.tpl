<div id="page-content" class="row-fluid">
	<div id="sidebar" class="span3">
		{include file="MyResearch/menu.tpl"}
		
		{include file="Admin/menu.tpl"}
	</div>
	
	<div id="main-content" class="span9">
		<h2 id="pageTitle">{$shortPageTitle}</h2>
		<div class='adminTableRegion'>
			<table class="adminTable table table-bordered table-striped table-condensed">
				<thead>
					<tr>
						<th>Actions</th>
						{foreach from=$structure item=property key=id}
							{if !isset($property.hideInLists) || $property.hideInLists == false}
							<th><label title='{$property.description}'>{$property.label}</label></th>
							{/if}
						{/foreach}
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					{if isset($dataList) && is_array($dataList)}
						{foreach from=$dataList item=dataItem key=id}
						<tr class='{cycle values="odd,even"} {$dataItem->class}'>
						{if $dataItem->class != 'objectDeleted'}
							<td><a href='{$path}/{$module}/{$toolName}?objectAction=edit&amp;id={$id}'><span class='silk edit'>&nbsp;</span>Edit</a></td>
							{/if}
							{foreach from=$structure item=property}
								{assign var=propName value=$property.property}
								{assign var=propOldName value=$property.propertyOld}
								{assign var=propValue value=$dataItem->$propName}
								{assign var=propOldValue value=$dataItem->$propOldName}
								{if !isset($property.hideInLists) || $property.hideInLists == false}
									<td {if $propOldValue}class='fieldUpdated'{/if}>
									{if $property.type == 'text' || $property.type == 'label' || $property.type == 'hidden' || $property.type == 'file' || $property.type == 'integer'}
										{$propValue}{if $propOldValue} ({$propOldValue}){/if}
									{elseif $property.type == 'date'}
										{$propValue}{if $propOldValue} ({$propOldValue}){/if}
									{elseif $property.type == 'partialDate'}
										{assign var=propNameMonth value=$property.propNameMonth}
										{assign var=propMonthValue value=$dataItem->$propNameMonth}
										{assign var=propNameDay value=$property.propNameDay}
										{assign var=propDayValue value=$dataItem->$propDayValue}
										{assign var=propNameYear value=$property.propNameYear}
										{assign var=propYearValue value=$dataItem->$propNameYear}
										{if $propMonthValue}$propMonthValue{else}??{/if}/{if $propDayValue}$propDayValue{else}??{/if}/{if $propYearValue}$propYearValue{else}??{/if}
									{elseif $property.type == 'currency'}
										{assign var=propDisplayFormat value=$property.displayFormat}
										${$propValue|string_format:$propDisplayFormat}{if $propOldValue} (${$propOldValue|string_format:$propDisplayFormat}){/if}
									{elseif $property.type == 'enum'}
										{foreach from=$property.values item=propertyName key=propertyValue}
											{if $propValue == $propertyValue}{$propertyName}{/if}
										{/foreach}
										{if $propOldValue}
											{foreach from=$property.values item=propertyName key=propertyValue}
												{if $propOldValue == $propertyValue} ({$propertyName}){/if}
											 {/foreach}
										{/if}
									{elseif $property.type == 'multiSelect'}
										{if is_array($propValue) && count($propValue) > 0}
											{foreach from=$property.values item=propertyName key=propertyValue}
												{if in_array($propertyValue, array_keys($propValue))}{$propertyName}<br/>{/if}
											{/foreach}
										{else}
											No values selected
										{/if}
									{elseif $property.type == 'oneToMany'}
										{if is_array($propValue) && count($propValue) > 0}
											{$propValue|@count}
										{else}
											Not set
										{/if}
									{elseif $property.type == 'checkbox'}
										{if ($propValue == 1)}Yes{else}No{/if}
										{if $propOldValue}
										{if ($propOldValue == 1)} (Yes){else} (No){/if}
										{/if}
									{else}
										Unknown type to display {$property.type}
									{/if}
									</td>
								{/if}
							{/foreach}
							{if $dataItem->class != 'objectDeleted'}
								<td>
									<a href='{$path}/{$module}/{$toolName}?objectAction=edit&amp;id={$id}'><span class="silk edit">&nbsp;</span>Edit</a>
									{if $additionalActions}
										{foreach from=$additionalActions item=action}
											<a href='{$action.path}&amp;id={$id}'>{$action.name}</a>
										{/foreach} 
									{/if}
								</td>
							{/if}
						</tr>
						{/foreach}
				{/if}
				</tbody>
			</table>
		</div>
		{if $canAddNew}
			<form action="" method="get" id='addNewForm'>
				<div>
					<input type='hidden' name='objectAction' value='addNew' />
					<button type='submit' value='addNew' class="btn">Add New {$objectType}</button>
				</div>
			</form>
		{/if}
			
		{foreach from=$customListActions item=customAction}
			<form action="" method="get">
				<div>
					<input type='hidden' name='objectAction' value='{$customAction.action}' />
					<button type='submit' value='{$customAction.action}' class="btn">{$customAction.label}</button>
				</div>
			</form>
		{/foreach}
			
		{if $showExportAndCompare}
			<form action="" method="get" class="form-horizontal">
				<div>
					<input type='hidden' name='objectAction' value='export' />
					<button type='submit' value='export' class="btn">Export to file</button>
				</div>
			</form>
			<form action="" enctype="multipart/form-data" method="post" class="form-horizontal">
				<div>
					<input type="hidden" name="MAX_FILE_SIZE" value="100000" />
					<input type="hidden" name='objectAction' value='compare' />
					Choose a file to compare: <input name="uploadedfile" type="file" /> <input type="submit" value="Compare File" class="btn"/>
				</div>
			</form>
			<form action="" enctype="multipart/form-data" method="post" class="form-horizontal">
				<div>
					<input type="hidden" name="MAX_FILE_SIZE" value="100000" />
					<input type="hidden" name='objectAction' value='import' />
					Choose a file to import: <input name="uploadedfile" type="file" /> <input type="submit" value="Import File" class="btn"/>
					This should be a file that was exported from the VuFind Admin console. Trying to import another file could result in having a very long day of trying to put things back together.	In short, don't do it!
				</div>
			</form>
		{/if}
	</div>
</div>