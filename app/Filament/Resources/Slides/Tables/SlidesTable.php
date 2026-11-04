<?php

namespace App\Filament\Resources\Slides\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

class SlidesTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('image')
                    ->label(__('Banner'))
                    ->disk('public'),
                TextColumn::make('title')
                    ->label(__('Slide Title'))
                    ->searchable()
                    ->sortable(),
                TextColumn::make('link_url')
                    ->label(__('Link'))
                    ->limit(30)
                    ->color('primary'),
                TextColumn::make('start_date')
                    ->label(__('Start Date'))
                    ->date('d M Y')
                    ->sortable(),
                TextColumn::make('end_date')
                    ->label(__('End Date'))
                    ->date('d M Y')
                    ->sortable(),
                TextColumn::make('sort_order')
                    ->label(__('Sort Order'))
                    ->sortable(),
                IconColumn::make('is_active')
                    ->label(__('Active Status'))
                    ->boolean()
                    ->sortable(),
            ])
            ->defaultSort('sort_order', 'asc')
            ->filters([
                TernaryFilter::make('is_active')
                    ->label(__('Active Status')),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
