<?php

namespace App\Filament\Resources\Posts\Schemas;

use App\Enums\PostStatus;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class PostForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Konten Utama')
                    ->columnSpan(['lg' => 2])
                    ->components([
                        TextInput::make('title')
                            ->label('Judul Artikel')
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
                        Textarea::make('summary')
                            ->label('Ringkasan / Sinopsis')
                            ->rows(3)
                            ->helperText('Ringkasan singkat untuk tampilan kartu preview berita.'),
                        RichEditor::make('content')
                            ->label('Isi Artikel Lengkap')
                            ->required()
                            ->columnSpanFull(),
                    ]),

                Section::make('Publikasi & Pengaturan')
                    ->columnSpan(['lg' => 1])
                    ->components([
                        Select::make('category_id')
                            ->label('Kategori')
                            ->relationship('category', 'name')
                            ->searchable()
                            ->preload()
                            ->required(),
                        FileUpload::make('image')
                            ->label('Gambar Sampul (Thumbnail)')
                            ->image()
                            ->disk('public')
                            ->directory('posts')
                            ->maxSize(2048),
                        Select::make('status')
                            ->label('Status')
                            ->options(collect(PostStatus::cases())->mapWithKeys(fn (PostStatus $status) => [
                                $status->value => $status->label(),
                            ]))
                            ->default(PostStatus::Draft->value)
                            ->required(),
                        DateTimePicker::make('published_at')
                            ->label('Waktu Terbit')
                            ->default(now()),
                        Toggle::make('is_featured')
                            ->label('Artikel Unggulan / Headline')
                            ->default(false),
                        Hidden::make('user_id')
                            ->default(fn () => auth()->id()),
                    ]),
            ])
            ->columns(3);
    }
}
