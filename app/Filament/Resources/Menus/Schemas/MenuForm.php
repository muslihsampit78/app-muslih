<?php

namespace App\Filament\Resources\Menus\Schemas;

use App\Enums\MenuItemType;
use App\Enums\MenuLocation;
use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class MenuForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Menu Information'))
                    ->components([
                        TextInput::make('name')
                            ->label(__('Menu Name'))
                            ->required()
                            ->maxLength(255)
                            ->placeholder(__('e.g., Main Header Menu')),
                        Select::make('location')
                            ->label(__('Menu Location'))
                            ->options(collect(MenuLocation::cases())->mapWithKeys(fn (MenuLocation $loc) => [
                                $loc->value => $loc->label(),
                            ]))
                            ->default(MenuLocation::Header->value)
                            ->required(),
                        Toggle::make('is_active')
                            ->label(__('Active Status'))
                            ->default(true),
                    ])
                    ->columns(3),

                Section::make(__('Menu Items List'))
                    ->components([
                        Repeater::make('items')
                            ->label(__('Navigation Items'))
                            ->relationship('items')
                            ->orderColumn('sort_order')
                            ->schema([
                                TextInput::make('label')
                                    ->label(__('Label Text'))
                                    ->required(),
                                Select::make('type')
                                    ->label(__('Link Type'))
                                    ->options(collect(MenuItemType::cases())->mapWithKeys(fn (MenuItemType $t) => [
                                        $t->value => $t->label(),
                                    ]))
                                    ->default(MenuItemType::Custom->value)
                                    ->required(),
                                TextInput::make('url')
                                    ->label(__('URL Link / Path'))
                                    ->placeholder(__('/about-us or https://...'))
                                    ->required(),
                                Toggle::make('is_active')
                                    ->label(__('Active'))
                                    ->default(true),
                            ])
                            ->columns(4)
                            ->collapsible()
                            ->itemLabel(fn (array $state): ?string => $state['label'] ?? null),
                    ]),
            ]);
    }
}
