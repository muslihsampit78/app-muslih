<?php

namespace App\Filament\Resources\Pages\Schemas;

use App\Enums\PageStatus;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class PageForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Konten Halaman')
                    ->columnSpan(['lg' => 2])
                    ->components([
                        TextInput::make('title')
                            ->label('Judul Halaman')
                            ->required()
                            ->maxLength(255)
                            ->live(onBlur: true)
                            ->afterStateUpdated(function (string $operation, ?string $state, Set $set): void {
                                if ($operation === 'create' && filled($state)) {
                                    $set('slug', Str::slug($state));
                                }
                            }),
                        TextInput::make('slug')
                            ->label('Slug')
                            ->required()
                            ->unique(ignoreRecord: true)
                            ->maxLength(255),
                        RichEditor::make('content')
                            ->label('Isi Konten')
                            ->required()
                            ->columnSpanFull(),
                    ]),

                Section::make('Pengaturan & Publikasi')
                    ->columnSpan(['lg' => 1])
                    ->components([
                        FileUpload::make('image')
                            ->label('Gambar Banner / Header')
                            ->image()
                            ->disk('public')
                            ->directory('pages')
                            ->maxSize(2048),
                        Select::make('status')
                            ->label('Status')
                            ->options(collect(PageStatus::cases())->mapWithKeys(fn (PageStatus $s) => [
                                $s->value => $s->label(),
                            ]))
                            ->default(PageStatus::Published->value)
                            ->required(),
                        TextInput::make('sort_order')
                            ->label('Urutan')
                            ->numeric()
                            ->default(0),
                        Toggle::make('show_in_menu')
                            ->label('Tampilkan di Menu Utama')
                            ->default(false),
                        Hidden::make('user_id')
                            ->default(fn () => auth()->id()),
                    ]),
            ])
            ->columns(3);
    }
}
